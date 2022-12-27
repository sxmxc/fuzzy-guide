extends Node2D

class_name StateMachine

const MODULE_NAME := "StateMachine"

var state: Object
var game_board

var history = []

func _ready():
	# Set the initial state to the first child node
	await get_parent().ready
	state = get_child(0)
	_enter_state()

func change_to(new_state):
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()

func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()

func _enter_state():
	if Data.DEBUG:
		Utils.logger.info("Entering state %s" % state.name, MODULE_NAME)
	# Give the new state a reference to this state machine script
	state.fsm = self
	state.game_board = get_parent()
	state.enter()
	EventBus.buses["GameBoardEvents"].emit_signal("game_state_changed", state.name)

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta):
	if state.has_method("process"):
		state.process(delta)

func _physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)

func _input(event):
	if state.has_method("input"):
		state.input(event)

func _unhandled_input(event):
	if state.has_method("unhandled_input"):
		state.unhandled_input(event)

func _unhandled_key_input(event):
	if state.has_method("unhandled_key_input"):
		state.unhandled_key_input(event)

#func _notification(what):
#	if state && state.has_method("notification"):
#		state.notification(what)
