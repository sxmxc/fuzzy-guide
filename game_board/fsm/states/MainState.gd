extends State

func enter():
	Utils.logger.info("FirstMainState entered", MODULE_NAME)
	Notifications.add_alert("[center][color=green]First Main Phase[/color] Player's Turn![/center]")
