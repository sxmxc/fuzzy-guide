extends ConfirmationDialog

signal name_confirmed(name: String)

@onready var text_value = get_node("TextEdit") as TextEdit
var deck_name : String


func _on_text_edit_text_changed():
	deck_name = text_value.text
	pass # Replace with function body.


func _on_confirmed():
	emit_signal("name_confirmed",deck_name)
	pass # Replace with function body.
