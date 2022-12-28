extends DraggableContainer

@export var starter_unit_type: Data.UNIT_TYPE

var unit_starting_empty_image = {
	Data.UNIT_TYPE.PAWN: preload("res://assets/chess-pawn.svg"),
	Data.UNIT_TYPE.ROOK: preload("res://assets/chess-rook.svg"),
	Data.UNIT_TYPE.KNIGHT: preload("res://assets/chess-knight.svg"),
	Data.UNIT_TYPE.BISHOP: preload("res://assets/chess-bishop.svg"),
	Data.UNIT_TYPE.QUEEN: preload("res://assets/chess-queen.svg"),
	Data.UNIT_TYPE.KING: preload("res://assets/chess-king.svg")
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _can_drop_data(_pos: Vector2, data) -> bool:
	var can_drop: bool = data is Node and data.is_in_group("Draggable") and data.card_type == starter_unit_type
	return can_drop
	
func _drop_data(_pos: Vector2, data) -> void:
	if item_list is TextureRect:
		item_list.texture = CardDB.get_card_by_name(data.label).card_image
		%StarterList.list_contents.append(CardDB.get_card_by_name(data.label).card_id)	
	emit_signal("item_dropped_on_target", data)
