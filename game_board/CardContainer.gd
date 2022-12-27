extends Area2D
class_name CardContainer


func add_card(card : Card):
	card.get_parent().remove_child(card)
	add_child(card)
	card.set_owner(self)

func get_cards() -> Array[Card]:
	var cards := []
	for i in get_children():
		if i is Card:
			cards.append(i)
	return cards

func get_top_card() -> Card:
	var top_card : Card
	for child in get_children():
		if child is Card:
			top_card = child as Card
			break
	if !top_card:
		return null
	return top_card
