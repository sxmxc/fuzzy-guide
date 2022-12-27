extends Node2D
class_name GameBoard
const MODULE_NAME := "GameBoard"

@onready var board = get_node("Board") as Board
@onready var player : Player = get_node("Player")
@onready var player_library_container = get_node("PlayerLibrary") as Node2D
@onready var player_hand_container = get_node("PlayerHand") as Node2D
@onready var player_graveyard_container = get_node("PlayerGraveyard") as Node2D
@onready var game_state_machine = get_node("StateMachine") as StateMachine
const card_template = preload("res://cards/card.tscn")
var current_game_phase := "NONE"
var player_library = []
var player_starters = []
var player_hand = []
var player_graveyard = []
var max_hand_size = Data.PLAYER_MAX_HAND
var is_dragging_card := false
var dragging_card : Card = null
var is_card_magnified := false

var unit_starting_positions = {
	Data.UNIT_TYPE.PAWN: ["a2","b2","c2","d2","e2","f2","g2","h2"],
	Data.UNIT_TYPE.ROOK: ["a1","h1"],
	Data.UNIT_TYPE.KNIGHT: ["b1","g1"],
	Data.UNIT_TYPE.BISHOP: ["c1", "f1"],
	Data.UNIT_TYPE.QUEEN: ["d1"],
	Data.UNIT_TYPE.KING: ["e1"]
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	#Console.register_env("GameBoard", self)
	EventBus.buses["GameBoardEvents"].card_selected.connect(_on_card_selected)
	EventBus.buses["GameBoardEvents"].tile_clicked.connect(_on_tile_clicked)
	EventBus.buses["GameBoardEvents"].game_state_changed.connect(_on_game_state_changed)
	EventBus.buses["GameBoardEvents"].draw_card_requested.connect(draw_card)
	EventBus.buses["GameBoardEvents"].redraw_hand_requested.connect(draw_hand)
	EventBus.buses["GameBoardEvents"].discard_hand_requested.connect(discard_hand)
	Utils.logger.info("Setting up Player Library", MODULE_NAME)
	player_library = player.get_current_deck_contents()
	player_starters = player.get_current_deck_starters()
	player_library_container.initialize(player_library)
	Utils.logger.info("ready", MODULE_NAME)
	Notifications.add_message("[color=green][Info][/color] GameBoard [b]Ready[/b]")


func draw_card():
	if !player_library.is_empty():
		var top_card = player_library_container.get_top_card() as Card
		player_library.remove_at(0)
		top_card.flip_card()
		move_to_hand(top_card)
	else:
		Utils.logger.info("Draw requested on empty library", MODULE_NAME)

func draw_starters():
	if !player_starters.is_empty():
		for card_id in player_starters:
			var card = card_template.instantiate()
			card.card_data = CardDB.get_card_by_id(card_id)
			card.init_data()
			card.name = card.card_data.card_name
			add_child(card)
			card.set_owner(self)
			card.gameboard = self
			card.update_card_view()
			card.position = -card.size/2
			card.starting_position = card.position
			card.starting_rotation = global_rotation
			card.front_facing = true
			move_to_hand(card)
	else:
		Utils.logger.warning("Draw requested on empty starters", MODULE_NAME)


func move_to_hand(card: Card):
	card.is_moving = true
	var center_destination := Utils.get_screen_center() - Utils.get_center(card.size)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", center_destination, 2).from(player_library_container.global_position)
	tween.tween_property(card, "global_position", player_hand_container.get_global_card_destination(card.get_index()-1),1).from(center_destination)
	player_hand.append(card.card_data.card_id)
	player_hand_container.add_card(card)
	await tween.finished
	EventBus.buses["GameBoardEvents"].emit_signal("draw_card_finished")
	Notifications.add_message(" Player drew card")
	card.is_moving = false


func move_to_graveyard(card: Card):
	card.in_graveyard = true
	card.get_node("Highlight").visible = false
	card.highlighted = false
	card.dragging = false
	card.starting_rotation = player_graveyard_container.global_rotation
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", player_graveyard_container.global_position - Utils.get_center(card.size) ,1)
	for i in player_hand.size() - 1:
		if player_hand[i] == card.card_data.card_id:
			player_hand.remove_at(i)
			break
	player_graveyard.append(card.card_data.card_id)
	player_graveyard_container.add_card(card)
	card.unmagnify_card()
	await tween.finished
	card.is_moving = false


func _on_card_selected(card):
	Utils.logger.info("Card selected: %s" % card.card_name, MODULE_NAME)
	dragging_card = card
	is_dragging_card = true
	pass

func _on_tile_clicked(tile: BoardTile):
	Utils.logger.info("Tile clicked: %s %s" % [tile.tile_data["board_position"], str(tile.tile_data["file"]) + tile.tile_data["rank"]], MODULE_NAME)
	if dragging_card:
		Utils.logger.info("Card %s requesting tile: %s %s" % [dragging_card.card_name,tile.tile_data["board_position"], str(tile.tile_data["file"]) + tile.tile_data["rank"]])
		if tile.valid and !tile.current_unit:
			var unit = load("res://units/Unit.tscn").instantiate() as Unit
			unit.initialize(dragging_card)
			tile.add_unit(unit)
			move_to_graveyard(dragging_card)
			is_dragging_card = false
			dragging_card = null
			board.add_child(unit)
			unit.position = tile.position
			Notifications.add_message("[color=green][Info][/color] Player placed [b]%s[/b]" % unit.unit_data.unit_name)
		else:
			Notifications.add_message("[color=red][Error][/color] Square [b]%s[/b] not valid" % str(tile.tile_data.file + tile.tile_data.rank))
	pass

func _on_game_state_changed(state: String):
	current_game_phase = state

func _process(delta):

	#TODO name dis better and dont call here yo
	get_node("%GameStateLabel").set_text("Turn phase: " + current_game_phase)
	pass

func draw_hand():
	for i in max_hand_size:
		draw_card()
		await get_tree().create_timer(.5).timeout
	EventBus.buses["GameBoardEvents"].emit_signal("draw_hand_finished")


func discard_hand():
	for card in player_hand_container.get_cards():
		move_to_graveyard(card)
		await get_tree().create_timer(.5).timeout
	EventBus.buses["GameBoardEvents"].emit_signal("discard_hand_finished")
	Notifications.add_message("[color=green][Info][/color] Player discarded hand")
