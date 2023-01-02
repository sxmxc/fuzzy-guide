class_name DialogueResource extends Resource

@icon("./assets/icon.svg")


func get_next_dialogue_line(title: String, extra_game_states: Array = []) -> Dictionary:
	# NOTE: For some reason get_singleton doesn't work here so we have to get creative
	var tree: SceneTree = Engine.get_main_loop()
	if tree:
		var dialogue_manager = tree.current_scene.get_node_or_null("/root/DialogueManager")
		if dialogue_manager != null:
			return await dialogue_manager.get_next_dialogue_line(self, title, extra_game_states)

	assert(false, "The \"DialogueManager\" autoload does not appear to be loaded.")
	return {}
