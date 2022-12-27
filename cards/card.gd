extends Control
class_name Card



@onready var card_back = get_node("CardBack")
@onready var card_front = get_node("CardFront")
@onready var card_image = get_node("CardFront/CardImage") as TextureRect
@onready var card_name_label = get_node("CardFront/CardName") as Label
@onready var card_target_label = get_node("%CardTargetTypeLabel") as Label
@onready var card_flavor_text_label = get_node("CardFront/FlavorText") as RichTextLabel
@onready var card_ability_text_label = get_node("CardFront/AbilityText") as RichTextLabel
@onready var card_type_label = get_node("%CardTypeLabel") as Label

@export var card_data : CardData
@export var front_facing = false


var dragging := false
var magnified := false
var highlighted := false
var in_graveyard := false
var is_moving := false

var starting_position := Vector2.ZERO
var starting_rotation : float
var card_size : Vector2

var card_name : String
var card_flavor_text : String
var card_ability_text : String
var card_value
var card_type : Data.CARD_TYPE
var card_target_type : Data.UNIT_TYPE

var gameboard : GameBoard

# Called when the node enters the scene tree for the first time.
func _ready():
	card_front.visible = front_facing
	card_back.visible = !front_facing
	card_size = $CardBack.size
	pass # Replace with function body.


func _process(_delta):
	card_front.visible = front_facing
	card_back.visible = !front_facing


func _input(_event):
	if dragging:
		global_position = get_global_mouse_position()

func init_data():
	card_name = card_data.card_name
	card_ability_text = card_data.card_ability_text
	card_flavor_text = card_data.card_flavor_text
	card_value = card_data.card_value
	card_type = card_data.card_type
	card_target_type = card_data.card_target_type

func flip_card():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(.01, 1), .5)
	tween.tween_callback(flip_card_cb)

func flip_card_cb():
	var tween = get_tree().create_tween()
	card_front.visible = !front_facing
	card_back.visible = front_facing
	tween.tween_property(self, "scale", Vector2(1, 1), .5)
	front_facing = !front_facing

func update_card_view():
	card_name_label.set_text(card_name)
	card_ability_text_label.set_text(card_ability_text)
	card_flavor_text_label.set_text(card_flavor_text)
	card_image.texture = card_data.card_image
#	card_type_label.text = Data.CARD_TYPE.keys()[card_type]
#	card_target_label.text = Data.UNIT_TYPE.keys()[card_target_type]

func magnify_card():
	z_index = 1
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", Vector2(position.x, position.y - 150), .5).from(starting_position)
	tween.tween_property(self, "rotation", 0, .5).from(starting_rotation)
	tween.tween_property(self, "scale", Vector2(1.5,1.5), .5)
	magnified = true
	gameboard.is_card_magnified = true


func unmagnify_card():
	z_index = 0
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", starting_position, .5)
	tween.tween_property(self, "rotation", starting_rotation, .5)
	tween.tween_property(self, "scale", Vector2(1,1), .5)
	magnified = false
	gameboard.is_card_magnified = false



func _on_mouse_entered():
	if !magnified and !gameboard.is_card_magnified and !dragging and front_facing and !in_graveyard:
		get_node("Highlight").visible = true
		highlighted = true
		magnify_card()
	pass # Replace with function body.


func _on_mouse_exited():
	if not Rect2(Vector2(),size).has_point(get_local_mouse_position()):
		if magnified and !dragging and front_facing and !in_graveyard:
			get_node("Highlight").visible = false
			highlighted = false
			unmagnify_card()
	pass # Replace with function body.


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT && event.pressed:
			if !dragging:
				dragging = true
				var tween = get_tree().create_tween()
				tween.set_parallel(true)
				tween.tween_property(self, "scale", Vector2(.75,.75), .5)
				EventBus.buses["GameBoardEvents"].emit_signal("card_selected", self)
			else:
				dragging = false
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_RIGHT && event.pressed:
			if !dragging:
				flip_card()

	pass # Replace with function body.
