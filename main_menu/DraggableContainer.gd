extends Panel
class_name DraggableContainer

signal item_dropped_on_target(draggable : Draggable)
var draggable: PackedScene = preload("res://main_menu/DraggableItem.tscn")

@onready var item_list = get_child(0).get_child(0)


func _can_drop_data(pos: Vector2, data) -> bool:
	var can_drop: bool = data is Node and data.is_in_group("Draggable")
	return can_drop
	
func _drop_data(pos: Vector2, data) -> void:
	var draggable_copy: ColorRect = draggable.instantiate()
	draggable_copy.id = data.id
	draggable_copy.label = data.label
	#draggable_copy.dropped_on_target = true
	item_list.add_child(draggable_copy)
	emit_signal("item_dropped_on_target", data)

