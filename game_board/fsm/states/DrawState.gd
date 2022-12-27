extends State

func enter():
	Utils.logger.info("DrawState entered", MODULE_NAME)
	if !game_board.player_library.is_empty():
		game_board.draw_card()
		await EventBus.buses["GameBoardEvents"].draw_card_finished
		exit("MainState")
	else:
		exit("EndState")
	pass
