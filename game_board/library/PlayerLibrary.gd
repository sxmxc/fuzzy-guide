extends CardContainer
const MODULE_NAME := "PlayerLibraryContainer"

const card_template = preload("res://cards/card.tscn")

func _ready():
	Utils.logger.info("ready", MODULE_NAME)

func initialize(player_library):
	Utils.logger.info("initializing", MODULE_NAME)
	randomize()
	player_library.shuffle()
	for id in player_library:
		var card = card_template.instantiate()
		card.card_data = CardDB.get_card_by_id(id)
		card.init_data()
		card.name = card.card_data.card_name
		card.front_facing = false
		add_child(card)
		card.set_owner(self)
		card.gameboard = owner as GameBoard
		card.update_card_view()
		card.position = -card.size/2
		card.starting_position = card.position
		card.starting_rotation = global_rotation
