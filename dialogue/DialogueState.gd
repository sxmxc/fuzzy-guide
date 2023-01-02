extends Node

var player_name = "Steebo"
var voice_in_head = "Moose"
var has_played_char_intro := false


func get_dialogue_text_input():
	var popup = load("res://dialogue/NameInputDialog.tscn").instantiate()
	get_tree().root.add_child(popup)
	popup.popup_centered()
	await popup.confirmed
	player_name = popup.name_edit.text
	popup.queue_free()
