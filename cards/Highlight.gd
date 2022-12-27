extends TextureRect

@onready var shader_mat = material as ShaderMaterial
var hue := 0.0

func _ready() -> void:
	ascend_color()

func ascend_color():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"hue", 1, 2)
	tween.tween_callback(descend_color)

func descend_color():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"hue", 0, 2)
	tween.tween_callback(ascend_color)

func _process(delta: float) -> void:
	var current_value = shader_mat.get_shader_parameter("color").v
	var current_shade = shader_mat.get_shader_parameter("color").s
	shader_mat.set_shader_parameter("color", Color.from_hsv(hue,current_shade,current_value))
