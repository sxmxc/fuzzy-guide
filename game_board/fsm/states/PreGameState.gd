extends State


func enter():
	Utils.logger.info("PreGameState entered", MODULE_NAME)
	Notifications.add_alert("[center][color=green][Pre-Game Phase][/color] Place your starters on the board[/center]")
	game_board.draw_starters()
	#TODO clean up this shyty shyte
	await get_node("%TopScreenButton").pressed
	game_board.draw_hand()
	get_node("%TopScreenButton").visible = false
	await get_tree().create_timer(3).timeout
	exit("DrawState")
