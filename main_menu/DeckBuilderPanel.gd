extends Panel

signal back_requested

@onready var deck_list = get_node("%DeckList") as ItemList
@onready var deck_builder = get_node("TabContainer/DeckBuilder")

var player_data: PlayerData
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if deck_list.get_selected_items().is_empty():
		get_node("%DeckEditButton").disabled = true
	else:
		get_node("%DeckEditButton").disabled = false
	pass

func load_data(data: PlayerData):
	player_data = data
	for deck in data.player_decks:
		deck_list.add_item(deck)

func edit_deck(deck_name: String):
	deck_builder.initialize(player_data, deck_name)
	$TabContainer.current_tab = 1
	pass



func _on_deck_edit_button_pressed():
	edit_deck(deck_list.get_item_text(deck_list.get_selected_items()[0]))
	pass # Replace with function body.


func _on_back_button_pressed():
	emit_signal("back_requested")
	pass # Replace with function body.


func _on_deck_builder_cancel_requested():
	$TabContainer.current_tab = 0
	pass # Replace with function body.
