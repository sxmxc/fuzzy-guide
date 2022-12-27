extends Node2D

signal map_data_generated
signal map_generation_done

const MODULE_NAME := "WorldGenerator"

@export var world_size := Vector2i(600, 200)
@export var noise := FastNoiseLite.new()

@export var temp_seed := 0
@export var moisture_seed := 0
@export var altitude_seed := 0

@onready var tilemap := $WorldMap
@onready var generating_total_label : Label = %GeneratingTotalLabel
@onready var generating_total_progress : ProgressBar = %GeneratingTotalProgress

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

var tile_data_threads = []
var max_data_threads = 4
var tile_draw_thread

var tiles_to_load := 0
var tiles_loaded := 0

var mutex

var exit_thread = false


var semaphore



func _init():
	pass

func _ready():
	tiles_to_load = world_size.x * world_size.y
	generating_total_progress.value = 0
	map_generation_done.connect(_on_map_generation_done)
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	exit_thread = false
	for i in max_data_threads:
		var thread = Thread.new()
		tile_data_threads.push_back(thread)
		thread.start(generate)
	semaphore.post()
	
func _process(delta):
	generating_total_label.text = "(%s/%s)" % [str(tiles_loaded), str(tiles_to_load)]
	var progress = (float(tiles_loaded) / float(tiles_to_load)) * 100
	generating_total_progress.value = progress
	
func _on_map_generation_done():
	Notifications.add_message("World generation done")
	Utils.logger.info("World generation done", MODULE_NAME)
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/ColorRect,"modulate", Color(Color.WHITE, 0), .5)
	
func set_tiles():
	for x in world_size.x:
		for y in world_size.y:
			mutex.lock()
			var pos = Vector2(x,y)
			var alt = altitude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			mutex.unlock()
			#Define Biomes
			#Ocean
			if alt < 0.2:
				#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["Water"])
				tilemap.set_cell(0,pos,0,tile_dict["Water"])
			#Beach
			elif between(alt, 0.2, .25):
				#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["Sand"])
				tilemap.set_cell(0,pos,0,tile_dict["Sand"])
			#Others
			elif between(alt, 0.25, .8):
				#Plains
				if between(moist, 0, 0.4) and between(temp, .2, .6):
					#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["Plains"])
					tilemap.set_cell(0,pos,0,tile_dict["Plains"])
				#Jungle
				elif between(moist, 0.4, 0.9) and temp > .6:
					#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["JungleGrass"])
					tilemap.set_cell(0,pos,0,tile_dict["JungleGrass"])
				#Swamp
				elif between(moist, 0.4, 0.9) and temp < .6:
					#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["SwampGrass"])
					tilemap.set_cell(0,pos,0,tile_dict["SwampGrass"])
				#Dessert
				elif temp > .7 and moist < .4:
					#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["Dirt"])
					tilemap.set_cell(0,pos,0,tile_dict["Dirt"])
				#Grassland
				else:
					#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["Grass"])
					tilemap.set_cell(0,pos,0,tile_dict["Grass"])
			else:
				tilemap.set_cell(0,pos,0,tile_dict["Snow"])
				#tilemap.call_deferred("set_cell", 0, pos, 0, tile_dict["Snow"])
			mutex.lock()
			tiles_loaded += 1
			mutex.unlock()
		await get_tree().create_timer(.01).timeout
	emit_signal("map_generation_done")
	
func generate():
	while (true):
		semaphore.wait()
		mutex.lock()
		var should_exit = exit_thread
		mutex.unlock()
		
		if should_exit:
			break
		
		mutex.lock()
		Notifications.add_message("Generating World...")
		Utils.logger.info("Generating World", MODULE_NAME)
		Notifications.add_message("Generating temprature...")
		Utils.logger.info("Generating temprature", MODULE_NAME)
		temp_seed = randi()
		temperature = generate_noise_map(5, temp_seed)
		Notifications.add_message("Generating moisture...")
		Utils.logger.info("Generating moisture", MODULE_NAME)
		moisture_seed = randi()
		moisture = generate_noise_map(5, moisture_seed)
		Notifications.add_message("Generating altitude...")
		Utils.logger.info("Generating altitude", MODULE_NAME)
		altitude_seed = randi()
		altitude = generate_noise_map(5, altitude_seed)
		Notifications.add_message("Generating biomes...")
		Utils.logger.info("Generating biomes", MODULE_NAME)
		mutex.unlock()
		tile_draw_thread = Thread.new()
		tile_draw_thread.start(set_tiles)
		
func generate_noise_map(oct, seed := randi()):
	mutex.lock()
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	noise.seed = seed
	noise.fractal_octaves = oct
	var data_grid = {}
	for x in world_size.x:
		for y in world_size.y:
			var rand = 2 *(abs(noise.get_noise_2d(x,y)))
			data_grid[Vector2(x,y)] = rand
	mutex.unlock()
	return data_grid


func _input(event):
	if event.is_action_pressed("ui_accept"):
		var tween = get_tree().create_tween()
		tween.tween_property($CanvasLayer/ColorRect,"modulate", Color(Color.WHITE, 1), .5)
		mutex.lock()
		tiles_loaded = 0
		generating_total_progress.value = 0
		mutex.unlock()
		semaphore.post()

func between(val, start, end):
	if start <= val and val < end:
		return true

func _exit_tree():
	mutex.lock()
	exit_thread = true
	mutex.unlock()
	semaphore.post()
	for i in tile_data_threads:
		i.wait_to_finish()
	tile_draw_thread.wait_to_finish()

	
