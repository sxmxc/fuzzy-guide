extends Control
class_name PlayerMenu

func set_player_menu_data(data: PlayerData):
	get_node("MenuContainer/PlayerInfo").set_player_data(data)
	get_node("MenuContainer/CardCollectionMenu").set_player_data(data)
	get_node("MenuContainer/DeckCollectionMenu").set_player_data(data)


