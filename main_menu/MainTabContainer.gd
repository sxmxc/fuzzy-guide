extends TabContainer
class_name MenuTabContainer

var tab_dict = {
	"Main": 0,
	"Settings": 1,
	"CardLibrary": 2,
	"DeckBuilder": 3,
	"DevMenu": 4,
	"CharCreator": 5
}
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func change_tab(tab : String):
	if tab_dict.has(tab):
		current_tab = tab_dict[tab]
	pass

func _on_setting_button_pressed():
	change_tab("Settings")
	pass # Replace with function body.


func _on_card_library_button_pressed():
	change_tab("CardLibrary")
	pass # Replace with function body.


func _on_deck_builder_button_pressed():
	change_tab("DeckBuilder")
	pass # Replace with function body.


func _on_dev_button_pressed():
	change_tab("DevMenu")
	pass # Replace with function body.


func _on_dev_back_button_pressed():
	change_tab("Main")
	pass # Replace with function body.


func _on_dev_scene_button_pressed():
	Game.change_scene("res://dev/dev.tscn", true, Data.TRANSITION_IMAGE_PATH)
	pass # Replace with function body.


func _on_dev_sandbox_button_pressed():
	Game.change_scene("res://game_board/GameBoard.tscn", false, Data.TRANSITION_IMAGE_PATH)
	pass # Replace with function body.

func load_data(data: PlayerData):
	get_node("DeckBuilder").load_data(data)


func _on_dev_world_gen_button_pressed():
	Game.change_scene("res://world/world.tscn", false, Data.TRANSITION_IMAGE_PATH)
	pass # Replace with function body.


func _on_dev_char_creator_button_pressed():
	change_tab("CharCreator")
	pass # Replace with function body.


func _on_character_creator_back_requested():
	change_tab("Main")
	pass # Replace with function body.


func _on_deck_builder_back_requested():
	change_tab("Main")
	pass # Replace with function body.



