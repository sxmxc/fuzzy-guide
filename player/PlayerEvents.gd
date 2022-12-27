extends "res://event_bus/Events.gd"

signal player_data_updated

signal card_collected(id: String)
signal card_added(success: bool)

signal deck_created(deck_name: String)
signal deck_equipped(deck_name: String)
signal deck_updated(deck_name: String)
signal deck_deleted(deck_name: String)

func _ready():
	player_data_updated.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "player_data_updated"))
	card_collected.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "card_collected"))
	card_added.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "card_added"))
	deck_created.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "deck_created"))
	deck_equipped.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "deck_equipped"))
	deck_updated.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "deck_updated"))
	deck_deleted.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "deck_deleted"))
