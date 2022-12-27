extends Node2D
class_name Unit

@export var unit_data := {
	"type": Data.UNIT_TYPE,
	"unit_id": "",
	"unit_name":"",
}

@onready var sprite := $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_type() -> Data.UNIT_TYPE:
	return unit_data.type

func get_unit_name() -> String:
	return unit_data.unit_name

func initialize(card: Card):
	await ready
	unit_data.unit_id = card.card_data.card_id
	unit_data.type = card.card_data.card_target_type
	unit_data.unit_name = card.card_data.card_name
	sprite.texture = card.card_data.unit_image as Texture2D
