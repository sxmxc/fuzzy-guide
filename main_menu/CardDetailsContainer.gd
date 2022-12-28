extends MarginContainer

@onready var card_id_label = get_node("%CardIDValue") as Label
@onready var card_image_texture = get_node("%CardImage") as TextureRect
@onready var card_name_label = get_node("%CardNameValue")  as Label
@onready var card_type_label = get_node("%CardTypeValue")  as Label
@onready var card_target_label = get_node("%CardTargetValue")  as Label
@onready var card_ability_text = get_node("%AbilityText")  as Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_data(card_data: CardData):
	card_id_label.text = card_data.card_id
	card_image_texture.texture = card_data.card_image
	card_name_label.text = card_data.card_name
	#card_type_label.text = card_data.card_type
	#card_target_label.text = card_data.card_target_type
	card_ability_text.text = card_data.card_ability_text
