extends "res://event_bus/Events.gd"

signal card_selected(card: Card)
signal card_dropped_on_board(tile: BoardTile)
signal card_added_to_hand

signal redraw_hand_requested
signal draw_card_requested
signal discard_hand_requested

signal draw_card_finished
signal draw_hand_finished
signal discard_hand_finished

signal tile_clicked(tile: BoardTile)



signal game_state_changed(new_state: State)

func _ready():
	card_selected.connect(func(_args): Utils.logger.info("card_selected: %s" % _args, MODULE_NAME))
	card_dropped_on_board.connect(func(_args): Utils.logger.info("card_dropped_on_board: %s" % _args, MODULE_NAME))
	card_added_to_hand.connect(func(): Utils.logger.info("card_added_to_hand", MODULE_NAME))
	redraw_hand_requested.connect(func(): Utils.logger.info("redraw_hand_requested", MODULE_NAME))
	draw_card_requested.connect(func(): Utils.logger.info("draw_card_requested", MODULE_NAME))
	discard_hand_requested.connect(func(): Utils.logger.info("discard_hand_requested", MODULE_NAME))
	draw_card_finished.connect(func(): Utils.logger.info("draw_card_finished", MODULE_NAME))
	draw_hand_finished.connect(func(): Utils.logger.info("draw_hand_finished", MODULE_NAME))
	discard_hand_finished.connect(func(): Utils.logger.info("discard_hand_finished", MODULE_NAME))
	tile_clicked.connect(func(_args:BoardTile): Utils.logger.info("tile_clicked: %s" % _args.rankfile_label.text, MODULE_NAME))
	game_state_changed.connect(func(_args): Utils.logger.info("game_state_changed: %s" % _args, MODULE_NAME))
	pass
