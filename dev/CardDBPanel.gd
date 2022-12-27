extends Panel

@onready var id_input = get_node("%IDInput") as TextEdit
@onready var card_name_value = get_node("%CardNameValue") as Label
@onready var card_type_value = get_node("%CardTypeValue") as Label
@onready var card_target_value = get_node("%CardTargetValue") as Label
@onready var error_label = get_node("%ErrorLabel") as Label


# Called when the node enters the scene tree for the first time.
func _ready():
	card_name_value.set_text("")
	card_type_value.set_text("")
	card_target_value.set_text("")
	error_label.set_text("")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_lookup_button_pressed():
	var args = id_input.text
	if CardDB.has_card(args):
		var card_data = CardDB.get_card_by_id(args)
		card_name_value.set_text(card_data.card_name)
		##TODO bug fix coming soon for this
#		card_type_value.set_text(Data.CARD_TYPE.keys()[card_data.card_type])
#		card_target_value.set_text(Data.UNIT_TYPE.keys()[card_data.card_target_type])
	else:
		card_name_value.set_text("")
		card_type_value.set_text("")
		card_target_value.set_text("")
		error_label.set_text("Card not found")
	pass # Replace with function body.


func _on_add_button_pressed():
	var args = id_input.text
	card_name_value.set_text("")
	card_type_value.set_text("")
	card_target_value.set_text("")
	if CardDB.has_card(args):
		EventBus.buses["PlayerEvents"].emit_signal("card_collected", args)
		var success = await EventBus.buses["PlayerEvents"].card_added
		if !success:
			error_label.set_text("Error attempting to add card")
		error_label.set_text("Success")
	else:
		card_name_value.set_text("")
		card_type_value.set_text("")
		card_target_value.set_text("")
		error_label.set_text("Card not found")
	pass # Replace with function body.
