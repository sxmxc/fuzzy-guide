extends ColorRect
class_name Draggable

@export var id: int = 0
@onready var selected_rect = $SelectedRect
var label : String = "Testing"
var card_type: Data.UNIT_TYPE
var is_selected := false

var dropped_on_target := false

signal draggable_hovered(item)
signal draggable_clicked(item)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Draggable")
	$Label.text = label
	pass # Replace with function body.

func _process(_delta):
	selected_rect.visible = is_selected

func _get_drag_data(_position: Vector2):
	print("get_drag_data has run")
	if not dropped_on_target:
		set_drag_preview(_get_preview_control())
		return self
	
func _get_preview_control() -> Control:
	var preview = ColorRect.new()
	preview.size = size
	var preview_color = color
	preview_color.a = .5
	preview.color = preview_color
	preview.set_rotation(.1)
	return preview


func _on_mouse_entered():
	emit_signal("draggable_hovered", self)
	is_selected = true
	pass # Replace with function body.


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT && event.pressed:
			
			emit_signal("draggable_clicked",self)
	pass # Replace with function body.


func _on_mouse_exited():
	is_selected = false
	pass # Replace with function body.
