extends MarginContainer

@onready var collection_list = get_node("%CollectionItemList") as ItemList
@onready var card_id_label = get_node("%CardIDValue") as Label
@onready var card_name_label = get_node("%CardNameValue") as Label
@onready var card_type_label = get_node("%CardTypeValue") as Label
@onready var card_target_label = get_node("%CardTargetValue") as Label
@onready var card_count_label = get_node("%CardCount") as Label
@onready var card_image = get_node("%CardImage") as TextureRect

var list_definitions: Dictionary

var player_data : PlayerData

func set_player_data(data: PlayerData):
	player_data = data
	update_collection_list()

func update_collection_list():
	collection_list.deselect_all()
	collection_list.clear()
	list_definitions.clear()
	var idx = 0
	var cards_added = []
	for card_id in player_data.player_collected_cards:
		if !cards_added.has(card_id):
			collection_list.add_item(CardDB.get_card_by_id(card_id).card_name)
			list_definitions[idx] = card_id
			cards_added.append(card_id)
			idx += 1
	if !cards_added.is_empty():
		collection_list.select(0)
		collection_list.emit_signal("item_selected", 0)

func display_card(id: String):
	var card = CardDB.get_card_by_id(id)
	card_id_label.text = card.card_id
	card_name_label.text = card.card_name
	##TODO bug fix coming for this
	#card_type_label.text = Data.CARD_TYPE.keys()[card.card_type]
	#card_target_label.text = Data.UNIT_TYPE.keys()[card.card_target_type]
	card_image.texture = card.card_image
	var count = 0
	for crd in player_data.player_collected_cards:
		if crd == id:
			count +=1
	card_count_label.text = str(count)


func _on_collection_item_list_item_selected(index):
	display_card(list_definitions[index])
	pass # Replace with function body.




