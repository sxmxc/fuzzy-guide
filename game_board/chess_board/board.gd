extends Node2D
class_name Board

const MODULE_NAME := "ChessBoard"


@export var board_size : Vector2i = Vector2i(8,8)

var board_tiles : Array
@onready var board_tile_container = get_node("BoardTiles")
@onready var board_sprite = get_node("BoardSprite") as Sprite2D

var file_dict = {1:"a",2:"b",3:"c",4:"d",5:"e",6:"f",7:"g",8:"h"}


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_board()
	Utils.logger.info("ready", MODULE_NAME)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func initialize_board():
	var tile_size = Vector2(board_sprite.texture.get_width() * board_sprite.scale.x / board_size.x, board_sprite.texture.get_height() * board_sprite.scale.y / board_size.y)
	board_tiles = []
	for col in range(board_size.x):
		board_tiles.append([])
		for row in range(board_size.y):
			var tile = load("res://game_board/chess_board/BoardTile.tscn").instantiate() as BoardTile
			tile.tile_data["board_position"] = Vector2i(row+1, board_size.x - col)
			tile.tile_data["rank"] = str(board_size.x - col)
			tile.tile_data["file"] = file_dict[row+1]
			tile.name = str(tile.tile_data["board_position"])
			tile.tile_size = tile_size
			tile.position = Vector2(row * tile_size.x, col * tile_size.y)
			board_tiles[col].append(tile)
			board_tile_container.add_child(tile)
			tile.initialize(owner)
	pass

func get_tile_content(pos = Vector2i()):
	return board_tiles[pos.x][pos.y]

func is_tile_vacant(pos=Vector2i(), direction=Vector2i()):
	var tile_pos = pos + direction
	if tile_pos.x < board_size.x and tile_pos.x >= 0:
		if tile_pos.y < board_size.y and tile_pos.y >= 0:
			return true if board_tiles[tile_pos.x][tile_pos.y].unit == null else false
	return false

