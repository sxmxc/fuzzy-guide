extends MarginContainer

@onready var current_deck_label = get_node("%CurrentDeckLabel") as Label

var player_data : PlayerData
# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.buses["PlayerEvents"].player_data_updated.connect(_on_player_data_updated)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player_data(data: PlayerData):
	player_data = data
	update_info()

func _on_player_data_updated():
	update_info()

func update_info():
	current_deck_label.text = player_data.player_current_deck
