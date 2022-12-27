extends Control
class_name BoardTile

#var board_position: Vector2i

var current_unit: Unit
var tile_size: Vector2
var tile_data:= {
	"board_position": Vector2i.ZERO,
	"rank": "",
	"file": ""
}

var gameboard : GameBoard = null

@onready var tile_display = get_node("TileDisplay")
@onready var location_label = get_node("TileDisplay/LocationLabel")
@onready var rankfile_label = get_node("TileDisplay/RankFileLabel")

var highlighted = false
var valid = false

# Called when the node enters the scene tree for the first time.
func _ready():
	size = tile_size
	pass # Replace with function body.

func initialize(gb : GameBoard):
	gameboard = gb

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if highlighted:
		if gameboard.is_dragging_card and (gameboard.dragging_card.card_type == Data.CARD_TYPE.UNIT):
			var filerank = str(tile_data.file + tile_data.rank)
			var valid_tiles = gameboard.unit_starting_positions[gameboard.dragging_card.card_target_type]
			if filerank in valid_tiles and !current_unit:
				valid = true
			else:
				valid = false
			if valid:
				tile_display.get_node("TextureRect").modulate = Color(Color.GREEN, .5)
			else:
				tile_display.get_node("TextureRect").modulate = Color(Color.RED, .5)
		else:
			valid = false
			tile_display.get_node("TextureRect").modulate = Color(Color.BLUE, .5)
		tile_display.visible = true
	else:
		tile_display.visible = false
	pass

func remove_unit():
	current_unit = null
	pass

func add_unit(unit: Unit):
	current_unit = unit


func _on_mouse_entered():
	highlighted = true
	location_label.text = str(tile_data["board_position"])
	rankfile_label.text = str(tile_data["file"]) + tile_data["rank"]
	pass # Replace with function body.


func _on_mouse_exited():
	highlighted = false
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT && event.pressed:
			EventBus.buses["GameBoardEvents"].emit_signal("tile_clicked", self)
	pass # Replace with function body.
