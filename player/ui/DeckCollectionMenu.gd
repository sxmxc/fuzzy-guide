extends MarginContainer

@onready var deck_list = get_node("%DeckItemList") as ItemList
@onready var deck_content_list = get_node("%DeckContentList") as ItemList
@onready var new_deck_button = get_node("%NewDeckButton") as Button
@onready var equip_deck_button = get_node("%EquipDeckButton") as Button
@onready var edit_deck_button = get_node("%EditDeckButton") as Button
@onready var delete_deck_button = get_node("%DeleteDeckButton") as Button
@onready var deck_name_dialog = get_node("%DeckNameDialog") as ConfirmationDialog
@onready var deck_edit_dialog = get_node("%DeckEditDialog") as ConfirmationDialog
var player_data : PlayerData



# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.buses["PlayerEvents"].player_data_updated.connect(_on_player_data_updated)
	pass # Replace with function body.


func set_player_data(data: PlayerData):
	player_data = data
	update_deck_list()

func update_deck_list():
	deck_list.deselect_all()
	deck_list.clear()
	deck_content_list.clear()
	var decks_added = []
	for deck in player_data.player_decks:
		if deck == player_data.player_current_deck:
			deck_list.add_item(deck,load("res://player/ui/check-mark.svg"))
		else:
			deck_list.add_item(deck)
		decks_added.append(deck)
	edit_deck_button.disabled = true
	equip_deck_button.disabled = true
	delete_deck_button.disabled = true


func display_deck_details(deck_name: String):
	deck_content_list.clear()
	for card_id in player_data.player_decks[deck_name].deck_contents:
		deck_content_list.add_item(CardDB.get_card_by_id(card_id).card_name)

func _on_deck_item_list_item_selected(index):
	display_deck_details(deck_list.get_item_text(index))
	equip_deck_button.disabled = false
	edit_deck_button.disabled = false
	if deck_list.get_item_text(index) == player_data.player_current_deck:
		delete_deck_button.disabled = true
	else:
		delete_deck_button.disabled = false
	pass # Replace with function body.


func _on_new_deck_button_pressed():
	deck_name_dialog.popup_centered(Vector2i(200,100))
	pass # Replace with function body.


func _on_deck_item_list_empty_clicked(_at_position, _mouse_button_index):
	edit_deck_button.disabled = true
	equip_deck_button.disabled = true
	delete_deck_button.disabled = true
	deck_list.deselect_all()
	deck_content_list.deselect_all()
	deck_content_list.clear()
	pass # Replace with function body.

func _on_player_data_updated():
	update_deck_list()

func _on_deck_name_dialog_name_confirmed(deck_name):
	EventBus.buses["PlayerEvents"].emit_signal("deck_created", deck_name)
	pass # Replace with function body.


func _on_delete_deck_button_pressed():
	var deck_name = deck_list.get_item_text(deck_list.get_selected_items()[0])
	EventBus.buses["PlayerEvents"].emit_signal("deck_deleted", deck_name)
	pass # Replace with function body.


func _on_equip_deck_button_pressed():
	var deck_name = deck_list.get_item_text(deck_list.get_selected_items()[0])
	EventBus.buses["PlayerEvents"].emit_signal("deck_equipped", deck_name)
	pass # Replace with function body.


func _on_deck_edit_dialog_confirmed():
	var cards_to_add = []
	for i in deck_edit_dialog.current_deck_list.get_item_count():
		cards_to_add.append(deck_edit_dialog.current_deck_list.get_item_text(i))
	player_data.player_decks[deck_list.get_item_text(deck_list.get_selected_items()[0])].deck_contents.clear()
	for card in cards_to_add:
		player_data.player_decks[deck_list.get_item_text(deck_list.get_selected_items()[0])].deck_contents.append(CardDB.get_card_id(card))
	EventBus.buses["PlayerEvents"].emit_signal("deck_updated", deck_list.get_item_text(deck_list.get_selected_items()[0]))
	pass # Replace with function body.


func _on_edit_deck_button_pressed():
	var deck_name = deck_list.get_item_text(deck_list.get_selected_items()[0])
	deck_edit_dialog.selected_deck = deck_name
	deck_edit_dialog.title = "Edit " + deck_name
	deck_edit_dialog.player_data = player_data
	deck_edit_dialog.update_lists()
	deck_edit_dialog.popup_centered(Vector2(700,500))
	pass # Replace with function body.

