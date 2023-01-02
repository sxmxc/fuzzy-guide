extends Panel

const MODULE_NAME = "CharacterCreator"

signal back_requested


@export var dialogue_ballon := preload("res://dialogue/DefaultDialogueBalloon.tscn")

@onready var body_options := %BodyOptions as OptionButton
@onready var hair_options := %HairOptions as OptionButton
@onready var top_options := %TopOptions as OptionButton
@onready var bottom_options := %BottomOptions as OptionButton
@onready var shoes_options := %ShoesOptions as OptionButton
@onready var accessory_options := %AccessoryOptions as OptionButton

@onready var sprite_view := %SpriteView
@onready var char_animator := sprite_view.get_node("CharacterPlayer").get_node("AnimationPlayer") as AnimationPlayer
@onready var char_body_sprite := sprite_view.get_node("CharacterPlayer").get_node("Body") as Sprite2D
@onready var char_hair_sprite := sprite_view.get_node("CharacterPlayer").get_node("Hair") as Sprite2D
@onready var char_top_sprite := sprite_view.get_node("CharacterPlayer").get_node("Top") as Sprite2D
@onready var char_bottom_sprite := sprite_view.get_node("CharacterPlayer").get_node("Bottom") as Sprite2D
@onready var char_shoes_sprite := sprite_view.get_node("CharacterPlayer").get_node("Shoes") as Sprite2D
@onready var char_accessory_sprite := sprite_view.get_node("CharacterPlayer").get_node("Accessory") as Sprite2D

var available_bodies := []
var available_hairs := []
var available_tops := []
var available_bottoms := []
var available_shoes := []
var available_accessories := []

var dialogue_displayed := false
var _dev_unlocked := false

var animation_path_dict = {
	"idle" : "idle", 
	"jump" : "jump", 
	"run" : "run",
	"walk" : "walk"
}



var _current_body := {}
var _current_hair := {}
var _current_top := {}
var _current_bottoms := {}
var _current_shoes := {}
var _current_accessory := {}

var char_view_animated := false
var char_view_directions := ["right", "up", "left", "down"]
var char_view_current_direction := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Data.load_sprites()
	available_bodies = Data.get_sprites_by_type("body")
	available_hairs = Data.get_sprites_by_type("hair")
	available_tops = Data.get_sprites_by_type("top")
	available_bottoms = Data.get_sprites_by_type("bottom")
	available_accessories = Data.get_sprites_by_type("accessory")
	available_shoes = Data.get_sprites_by_type("shoes")
	
	_current_body = Data.SPRITE_DICT[available_bodies[0]]
	_current_hair = Data.SPRITE_DICT[available_hairs[0]]
	_current_top = Data.SPRITE_DICT[available_tops[0]]
	_current_bottoms = Data.SPRITE_DICT[available_bottoms[0]]
	_current_shoes = Data.SPRITE_DICT[available_shoes[0]]
	_current_accessory = Data.SPRITE_DICT[available_accessories[0]]

	_update_options_lists()
	
	_randomize_all()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	%SaveButton.visible = _dev_unlocked
	char_body_sprite.texture = _current_body.animations.idle
	char_hair_sprite.texture = _current_hair.animations.idle
	char_top_sprite.texture = _current_top.animations.idle
	char_bottom_sprite.texture = _current_bottoms.animations.idle
	char_shoes_sprite.texture = _current_shoes.animations.idle
	char_accessory_sprite.texture = _current_accessory.animations.idle
	char_animator.play("idle_" + char_view_directions[char_view_current_direction])
	char_animator.advance(0)
	if !char_view_animated and char_animator.is_playing():
		char_animator.stop()
	pass


func _on_char_creator_back_button_pressed():
	emit_signal("back_requested")
	pass # Replace with function body.

func _update_options_lists():
	body_options.clear()
	hair_options.clear()
	top_options.clear()
	bottom_options.clear()
	shoes_options.clear()
	accessory_options.clear()
	
	for body in available_bodies:
		body_options.add_item(body)
	for hair in available_hairs:
		hair_options.add_item(hair)
	for top in available_tops:
		top_options.add_item(top)
	for bottom in available_bottoms:
		bottom_options.add_item(bottom)
	for shoes in available_shoes:
		shoes_options.add_item(shoes)
	for accessory in available_accessories:
		accessory_options.add_item(accessory)

func set_char_name(string : String):
	%PlayerNameLabel.text = string

func unlock_dev():
	_dev_unlocked = true

func lock_dev():
	_dev_unlocked = false

func begin_game():
	Game.change_scene("res://world/world.tscn", false, Data.TRANSITION_IMAGE_PATH)

func _on_body_options_item_selected(index):
	_current_body = Data.SPRITE_DICT[body_options.get_item_text(index)]
	pass # Replace with function body.


func _on_hair_options_item_selected(index):
	_current_hair = Data.SPRITE_DICT[hair_options.get_item_text(index)]
	pass # Replace with function body.


func _on_top_options_item_selected(index):
	_current_top = Data.SPRITE_DICT[top_options.get_item_text(index)]
	pass # Replace with function body.


func _on_bottom_options_item_selected(index):
	_current_bottoms = Data.SPRITE_DICT[bottom_options.get_item_text(index)]
	pass # Replace with function body.


func _on_shoes_options_item_selected(index):
	_current_shoes = Data.SPRITE_DICT[shoes_options.get_item_text(index)]
	pass # Replace with function body.


func _on_accessory_options_item_selected(index):
	_current_accessory = Data.SPRITE_DICT[accessory_options.get_item_text(index)]
	pass # Replace with function body.

func _on_random_button_pressed():
	_randomize_all()
	pass # Replace with function body.

func _randomize_all():
	_random_body()
	_random_hair()
	_random_top()
	_random_bottom()
	_random_shoes()
	_random_accessory()

func _random_body():
	var random = randi_range(0, body_options.item_count -1)
	body_options.select(random)
	body_options.emit_signal("item_selected", random)
	pass
	
func _random_hair():
	var random = randi_range(0, hair_options.item_count -1)
	hair_options.select(random)
	hair_options.emit_signal("item_selected", random)
	pass
	
func _random_top():
	var	random = randi_range(0, top_options.item_count -1)
	top_options.select(random)
	top_options.emit_signal("item_selected", random)
	pass
	
func _random_bottom():
	var random = randi_range(0, bottom_options.item_count -1)
	bottom_options.select(random)
	bottom_options.emit_signal("item_selected", random)
	pass
	
func _random_shoes():
	var random = randi_range(0, shoes_options.item_count -1)
	shoes_options.select(random)
	shoes_options.emit_signal("item_selected", random)
	pass
	
func _random_accessory():
	var random = randi_range(0, accessory_options.item_count -1)
	accessory_options.select(random)
	accessory_options.emit_signal("item_selected", random)
	pass


func _on_accessory_random_button_pressed():
	_random_accessory()
	pass # Replace with function body.


func _on_shoes_random_button_pressed():
	_random_shoes()
	pass # Replace with function body.


func _on_bottom_random_button_pressed():
	_random_bottom()
	pass # Replace with function body.


func _on_top_random_button_button_up():
	_random_top()
	pass # Replace with function body.


func _on_hair_random_button_pressed():
	_random_hair()
	pass # Replace with function body.


func _on_body_random_button_pressed():
	_random_body()
	pass # Replace with function body.


func _on_char_view_animated_check_toggled(button_pressed):
	char_view_animated = button_pressed
	pass # Replace with function body.


func _on_char_view_rotate_left_pressed():
	if char_view_current_direction <= 0:
		char_view_current_direction = 3
	else:
		char_view_current_direction -= 1
	pass # Replace with function body.


func _on_char_view_rotate_right_pressed():
	if char_view_current_direction >= 3:
		char_view_current_direction = 0
	else:
		char_view_current_direction += 1
	pass # Replace with function body.


func _on_save_button_pressed():
	save_player()
	pass # Replace with function body.


func _on_visibility_changed():
	if visible:
		var dialogue = dialogue_ballon.instantiate()
		add_child(dialogue)
		dialogue.start(load("res://dialogue/character_creation.dialogue"), "Character Creation Intro", [self, DialogueState])
		dialogue_displayed = true
	pass # Replace with function body.

func save_player():
	var player_data = Game.get_player_data() as PlayerData
	player_data.player_current_body_sprite = body_options.get_item_text(body_options.get_selected_id())
	player_data.player_current_hair_sprite = hair_options.get_item_text(hair_options.get_selected_id())
	player_data.player_current_top_sprite = top_options.get_item_text(top_options.get_selected_id())
	player_data.player_current_bottom_sprite = bottom_options.get_item_text(bottom_options.get_selected_id())
	player_data.player_current_shoes_sprite = shoes_options.get_item_text(shoes_options.get_selected_id())
	player_data.player_current_accessory_sprite = accessory_options.get_item_text(accessory_options.get_selected_id())
	Game.save_player_data(player_data)


func _on_accept_button_pressed():
	var dialogue = dialogue_ballon.instantiate()
	add_child(dialogue)
	dialogue.start(load("res://dialogue/character_creation.dialogue"), "Character Creation Intro", [self, DialogueState])
	dialogue_displayed = true
	pass # Replace with function body.
