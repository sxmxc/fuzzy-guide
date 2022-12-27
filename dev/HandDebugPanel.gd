extends Panel


func _on_redraw_hand_button_pressed() -> void:
	EventBus.buses["GameBoardEvents"].emit_signal("redraw_hand_requested")
	pass # Replace with function body.


func _on_discard_hand_button_pressed() -> void:
	EventBus.buses["GameBoardEvents"].emit_signal("discard_hand_requested")
	pass # Replace with function body.


func _on_draw_card_button_pressed() -> void:
	EventBus.buses["GameBoardEvents"].emit_signal("draw_card_requested")
	pass # Replace with function body.
