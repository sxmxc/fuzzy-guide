extends AcceptDialog


@onready var name_edit: LineEdit = $NameEdit


func _ready() -> void:
	register_text_enter(name_edit)


### Signals
	

func _on_about_to_popup():
	name_edit.text = "Player"
	name_edit.call_deferred("grab_focus")
	name_edit.call_deferred("select_all")
	pass # Replace with function body.


func _on_close_requested():
	emit_signal("confirmed")
	pass # Replace with function body.
