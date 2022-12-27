extends Node2D

var buses: Dictionary

const MODULE_NAME := "EventBus"

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Events:
			buses[child.name] = child as Events
	Utils.logger.info("ready", MODULE_NAME)
	pass # Replace with function body.

