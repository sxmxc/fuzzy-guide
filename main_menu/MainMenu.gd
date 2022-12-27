extends Control

const MODULE_NAME := "MainMenu"
var _motd_counter = 0
var player_data : PlayerData
# Called when the node enters the scene tree for the first time.
func _ready():
	load_player_data()
	#await get_tree().create_timer(5).timeout
	display_motd_list()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func display_motd_list():
	if $MainTabContainer.current_tab == 0:
		if _motd_counter >= Data.MOTD_LIST.size():
			_motd_counter = 0
		Notifications.add_message(Data.MOTD_LIST[_motd_counter])
		_motd_counter += 1
	get_tree().create_timer(10).timeout.connect(display_motd_list)

func load_player_data():
	if !player_data:
		if ResourceLoader.exists(Data.PATH_PLAYER_SAVE):
			player_data = ResourceLoader.load(Data.PATH_PLAYER_SAVE)
			Notifications.add_message("Player data loaded")
			Utils.logger.info("Player data loaded", MODULE_NAME)
		else:
			player_data = PlayerData.new()
			ResourceSaver.save(player_data,Data.PATH_PLAYER_SAVE)
			Notifications.add_message("New player data created")
			Utils.logger.info("New player data created", MODULE_NAME)
	$MainTabContainer.load_data(player_data)

