extends Control

@onready var collection_list = get_node("%CollectionList")
@onready var deck_content_list = get_node("%DeckContentList")
@onready var starter_list = get_node("%StarterList")
@onready var deck_name_input = get_node("%DeckNameInput") as TextEdit
@onready var deck_count_label = get_node("%DeckCountLabel") as Label
@onready var starter_count_label = get_node("%StarterCountLabel") as Label
@onready var confirmation_dialog = get_node("ConfirmationDialog") as ConfirmationDialog

var draggable: PackedScene = preload("res://main_menu/DraggableItem.tscn")
var player_data : PlayerData


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Droppable"):
		node.connect("item_dropped_on_target", _on_item_dropped_in_list)

func _populate_collection_list(player: PlayerData, deck_name: String):
	var id = 0
	var player_collected = []
	for card in player.player_collected_cards:
		player_collected.append(card)
	var current_deck_content = []
	for card in player.player_decks[deck_name].deck_contents:
		current_deck_content.append(card)
	var cards_available = []
	for child in collection_list.get_children():
		child.queue_free()
	cards_available = Utils.array_dif(player_collected, current_deck_content)
	for card in cards_available:
		var list_item = draggable.instantiate()
		list_item.label = CardDB.get_card_by_id(card).card_name
		list_item.id = id
		list_item.card_type = CardDB.get_card_by_id(card).card_target_type
		collection_list.add_child(list_item)
		id += 1
	pass
	
func _populate_starter_list(player: PlayerData, deck_name: String):
#	for child in starter_list.get_children():
#		child.queue_free()
#	for card in player.player_decks[deck_name].deck_starters:
#		var list_item = draggable.instantiate()
#		list_item.label = CardDB.get_card_by_id(card).card_name
#		starter_list.add_child(list_item)
	pass

func _populate_deck_content_list(player: PlayerData, deck_name: String):
	var id = 0
	for child in deck_content_list.get_children():
		child.queue_free()
	for card in player.player_decks[deck_name].deck_contents:
		var list_item = draggable.instantiate()
		list_item.label = CardDB.get_card_by_id(card).card_name
		list_item.id = id
		list_item.card_type = CardDB.get_card_by_id(card).card_target_type
		deck_content_list.add_child(list_item)
		id += 1
	pass

func _on_item_dropped_in_list(dropped_item: Draggable) -> void:
	var source_container = dropped_item.get_parent()
	for drag_item in source_container.get_children():
		drag_item = (drag_item as Draggable)
		if drag_item.id == dropped_item.id:
			source_container.remove_child(drag_item)
			drag_item.queue_free()
	update_totals()

func _on_item_hovered(item: Draggable) -> void:
	print("item hovered received")

func _on_item_clicked(item: Draggable) -> void:
	print("item click received")
	%CardDetailsContainer.update_data(CardDB.get_card_by_name(item.label))

func initialize(player: PlayerData, deck_name: String):
	player_data = player
	_populate_collection_list(player, deck_name)
	_populate_starter_list(player, deck_name )
	_populate_deck_content_list(player, deck_name)
	deck_name_input.text = deck_name
	update_totals()
	for node in get_tree().get_nodes_in_group("Draggable"):
		node.connect("draggable_hovered", _on_item_hovered)
		node.connect("draggable_clicked", _on_item_clicked)

func update_totals():
	deck_count_label.text = "(" + str(deck_content_list.get_child_count()) + "/60)"
	starter_count_label.text = "(" + str(%StarterList.list_contents.size()) + "/16)"


func _on_save_button_pressed():
	confirmation_dialog.popup_centered()
	pass # Replace with function body.


func _on_cancel_button_pressed():
	pass # Replace with function body.

func _on_confirmation_dialog_confirmed():
	var cards_to_add = []
	var starters_to_add = %StarterList.list_contents
	for child in deck_content_list.get_children():
		cards_to_add.append(CardDB.get_card_by_name(child.label).card_id)
	player_data.player_decks[deck_name_input.text].deck_contents.clear()
	player_data.player_decks[deck_name_input.text].deck_starters.clear()
	for card in cards_to_add:
		player_data.player_decks[deck_name_input.text].deck_contents.append(card)
	for card in starters_to_add:
		player_data.player_decks[deck_name_input.text].deck_starters.append(card)
	EventBus.buses["PlayerEvents"].emit_signal("deck_updated", player_data.player_decks[deck_name_input.text].deck_name)
	save_player_data()
	Notifications.add_message("%s updated" % player_data.player_decks[deck_name_input.text].deck_name)
	pass # Replace with function body.

func save_player_data():
	if !player_data:
		if ResourceLoader.exists(Data.PATH_PLAYER_SAVE):
			player_data = ResourceLoader.load(Data.PATH_PLAYER_SAVE)
		else:
			player_data = PlayerData.new()
	ResourceSaver.save(player_data, Data.PATH_PLAYER_SAVE)
