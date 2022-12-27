extends ConfirmationDialog

var player_data : PlayerData
var selected_deck
@onready var current_collection_list = get_node("%CurrentCollectionList") as ItemList
@onready var current_deck_list = get_node("%CurrentDeckList") as ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_about_to_popup():
	pass # Replace with function body.

func update_lists():
	current_collection_list.clear()
	current_deck_list.clear()
	for cardID in player_data.player_collected_cards:
		current_collection_list.add_item(CardDB.get_card_by_id(cardID).card_name)
	for cardID in player_data.player_decks[selected_deck].deck_contents:
		current_deck_list.add_item(CardDB.get_card_by_id(cardID).card_name)
	var deck_list = []
	for i in current_deck_list.get_item_count():
		deck_list.append(current_deck_list.get_item_text(i))
	while deck_list:
		for i in current_collection_list.get_item_count():
			if deck_list[0] == current_collection_list.get_item_text(i):
				current_collection_list.remove_item(i)
				deck_list.pop_front()
				break


func _on_add_to_deck_button_pressed():
	var cards_to_add = []
	for idx in current_collection_list.get_selected_items():
		cards_to_add.append(current_collection_list.get_item_text(idx))
	while current_collection_list.get_selected_items():
		current_collection_list.remove_item(current_collection_list.get_selected_items()[0])
	current_collection_list.deselect_all()
	for card in cards_to_add:
		current_deck_list.add_item(CardDB.get_card_by_name(card).card_name)
	pass # Replace with function body.


func _on_remove_from_deck_button_pressed():
	var cards_to_remove = []
	for idx in current_deck_list.get_selected_items():
		cards_to_remove.append(current_deck_list.get_item_text(idx))
	while current_deck_list.get_selected_items():
		current_deck_list.remove_item(current_deck_list.get_selected_items()[0])
	current_deck_list.deselect_all()
	for card in cards_to_remove:
		current_collection_list.add_item(card)
	pass # Replace with function body.
