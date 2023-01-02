extends Node2D

signal map_generation_done

const MODULE_NAME := "WorldGenerator"

const WORLD_TILESET := preload("res://world/assets/tilesets/BasicBiomes.tres")

var chunk := preload("res://world/Chunk.gd")

@export var world_size := Vector2i(2025, 1080)
@export var chunk_size := Vector2i(75,40)
var num_chunks_x = world_size.x / chunk_size.x
var num_chunks_y = world_size.y / chunk_size.y
@export var noise := FastNoiseLite.new()

@export var temp_seed := 0
@export var moisture_seed := 0
@export var altitude_seed := 0

@onready var map_chunk_container := $MapChunkContainer
@onready var generating_total_label : Label = %GeneratingTotalLabel
@onready var generating_total_progress : ProgressBar = %GeneratingTotalProgress
@onready var chunk_total_label : Label = %ChunkTotalProgress
@onready var gen_stage_label : Label = %StageLabel

@onready var player = $CharacterPlayer

@onready var load_screen : CanvasLayer = $LoadCanvas

@onready var tile_dict := {
	"Grass": Vector2i(0,1),
	"Sand": Vector2i(1,1),
	"Water": Vector2i(2,1),
	"Plains": Vector2i(3,0),
	"Dirt": Vector2i(4,0),
	"JungleGrass": Vector2i(0,0),
	"SwampGrass": Vector2i(2,0),
	"Snow": Vector2i(1,0)
}

var temperature = {}
var moisture = {}
var altitude = {}
var biome = {}

var chunks = {}

var total_tiles := world_size.x * world_size.y
var tiles_loaded := 0

var total_chunks := num_chunks_x * num_chunks_y
var chunks_loaded := 0

var mutex

var exit_thread = false

var current_stage := "Generation beginning..."

var jobs : Array[TaskQueue.Task]

var is_loading := false


func _init():
	pass

func _ready():
	jobs.clear()
	show_loading_screen()
	randomize()
	total_tiles = world_size.x * world_size.y
	generating_total_progress.value = 0
	map_generation_done.connect(_on_map_generation_done)
	mutex = Mutex.new()
	generate()
	
func _physics_process(delta):
	if is_loading:
		mutex.lock()
		generating_total_label.text = "Tiles (%s/%s)" % [str(tiles_loaded), str(total_tiles)]
		mutex.unlock()
		mutex.lock()
		gen_stage_label.text = current_stage
		mutex.unlock()
		mutex.lock()
		var progress = (float(tiles_loaded) / float(total_tiles)) * 100
		generating_total_progress.value = progress
		if tiles_loaded == total_tiles:
			await get_tree().create_timer(3).timeout
			emit_signal("map_generation_done")
		mutex.unlock()
	else:
		update_visible_chunks()
	
func _on_map_generation_done():
#	Notifications.add_message("World generation done")
#	Utils.logger.info("World generation done", MODULE_NAME)
	current_stage = "Done"
	is_loading = false
	hide_loading_screen()
	
func set_tiles(chunk_tilemap : TileMap, chunk_coords : Vector2i):
	for x in chunk_size.x:
		for y in chunk_size.y:
			mutex.lock()
			var world_pos = Vector2(x + (chunk_size.x * chunk_coords.x ), y + (chunk_size.y * chunk_coords.y))
			var pos = Vector2(x,y)
			var alt = altitude[world_pos]
			var temp = temperature[world_pos]
			var moist = moisture[world_pos]
			mutex.unlock()
			
			#Define Biomes
			#Ocean
			if alt < 0.2:
				#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["Water"])
				mutex.lock()
				chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["Water"])
#				chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Ocean")
				mutex.unlock()
			#Beach
			elif between(alt, 0.2, .25):
				#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["Sand"])
				mutex.lock()
				chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["Sand"])
#				chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Beach")
				mutex.unlock()
			#Others
			elif between(alt, 0.25, .8):
				#Plains
				if between(moist, 0, 0.4) and between(temp, .2, .6):
					#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["Plains"])
					mutex.lock()
					chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["Plains"])
#					chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Plains")
					mutex.unlock()
				#Jungle
				elif between(moist, 0.4, 0.9) and temp > .6:
					#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["JungleGrass"])
					mutex.lock()
					chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["JungleGrass"])
#					chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Jungle")
					mutex.unlock()
				#Swamp
				elif between(moist, 0.4, 0.9) and temp < .6:
					#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["SwampGrass"])
					mutex.lock()
					chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["SwampGrass"])
#					chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Swamp")
					mutex.unlock()
				#Dessert
				elif temp > .7 and moist < .4:
					#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["Dirt"])
					mutex.lock()
					chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["Dirt"])
#					chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Dessert")
					mutex.unlock()
				#Grassland
				else:
					#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["Grass"])
					mutex.lock()
					chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["Grass"])
#					chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Grassland")
					mutex.unlock()
			else:
				mutex.lock()
				chunk_tilemap.call_deferred("set_cell", 0,pos,0,tile_dict["Snow"])
#				chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("biome", "Snow")
				#map_chunk_container.call_deferred("set_cell", 0, pos, 0, tile_dict["Snow"])
				mutex.unlock()
			mutex.lock()
#			chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("temperature", temp)
#			chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("moisture", moist)
#			chunk_tilemap.get_cell_tile_data(0,pos).set_custom_data("altitude", alt)
			tiles_loaded += 1
			mutex.unlock()
		await get_tree().process_frame
	mutex.lock()
	chunks_loaded +=1
	chunk_total_label.call_deferred("set_text", "Chunks (%s/%s)" % [str(chunks_loaded), str(total_chunks)])
	mutex.unlock()
	
	
func generate():
	is_loading = true
	
	current_stage = "Generating world data..."

	temp_seed = randi()
	temperature = generate_noise_map(5, temp_seed)
	moisture_seed = randi()
	moisture = generate_noise_map(5, moisture_seed)
	altitude_seed = randi()
	altitude = generate_noise_map(5, altitude_seed)


	current_stage = "Generating chunks..."


	var tally = 0
	for x in range(num_chunks_x):
		for y in range(num_chunks_y):
			var temp_map = chunk.new() as Chunk
			temp_map.chunk_coord = Vector2i(x,y)
			temp_map.chunk_id = tally
			temp_map.name = "Chunk(%s,%s)" % [str(x),str(y)]
			temp_map.tile_set = WORLD_TILESET
#			map_chunk_container.add_child(temp_map)
			chunks[Vector2i(x,y)] = temp_map
			temp_map.position = Vector2(WORLD_TILESET.tile_size.x * chunk_size.x * x, WORLD_TILESET.tile_size.y * chunk_size.y * y )
			var job = TaskQueue.create_task(set_tiles.bind(temp_map, Vector2i(x,y)), true,
				"Chunk(%s,%s) generation" % [str(x),str(y)]) as TaskQueue.Task
			jobs.append(job)
			tally += 1

func generate_noise_map(oct, _seed := randi()):
	mutex.lock()
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	noise.seed = _seed
	noise.fractal_octaves = oct
	mutex.unlock()
	var data_grid = {}
	for x in world_size.x:
		for y in world_size.y:
			mutex.lock()
			var rand = 2 *(abs(noise.get_noise_2d(x,y)))
			data_grid[Vector2(x,y)] = rand
			mutex.unlock()
	return data_grid


func _input(event):
	if event.is_action_pressed("ui_accept"):
		show_loading_screen()
		mutex.lock()
		chunks_loaded = 0
		tiles_loaded = 0
		generating_total_progress.value = 0
		mutex.unlock()
		generate()

# Enable or disable the chunks that are currently visible on the screen
func update_visible_chunks():
	# Get the player's position and determine which chunk they are currently in
	var player_chunk = Vector2i(player.get_position()) / (chunk_size * WORLD_TILESET.tile_size)
	
	# Enable the chunk that the player is currently in
	mutex.lock()
	if !chunks[player_chunk].is_inside_tree():
		map_chunk_container.add_child(chunks[player_chunk])
	chunks[player_chunk].visible = true
	mutex.unlock()
	
	mutex.lock()
	# Disable all other chunks
	for x in range(num_chunks_x):
		for y in range(num_chunks_y):
			if x != player_chunk.x or y != player_chunk.y:
				if chunks[Vector2i(x,y)].is_inside_tree():
					chunks[Vector2i(x,y)].visible = false
					chunks[Vector2i(x,y)].get_parent().remove_child(chunks[Vector2i(x,y)])
	mutex.unlock()


func show_loading_screen():
	load_screen.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(load_screen.get_node("ColorRect"),"modulate", Color(Color.WHITE, 1), .5)
	pass
	
func hide_loading_screen():
	var tween = get_tree().create_tween()
	tween.tween_property(load_screen.get_node("ColorRect"),"modulate", Color(Color.WHITE, 0), .5)
	tween.tween_callback(func(): load_screen.visible = false)
	pass

func between(val, start, end):
	if start <= val and val < end:
		return true


	
