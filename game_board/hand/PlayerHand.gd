extends CardContainer

@export var spread_curve := preload("res://game_board/hand/spread_curve.tres") as Curve
@export var rotation_curve := preload("res://game_board/hand/rotation_curve.tres") as Curve
@export var height_curve := preload("res://game_board/hand/height_curve.tres") as Curve

func _ready():
	#EventBus.buses["GameBoardEvents"].connect("draw_card_finished", update_hand)
	pass

func update_hand():
	for child in get_children() :
		if child is Card:
			var destination = get_card_destination(child.get_index())
			if !child.magnified and !child.is_moving:
				child.position = Vector2(destination.x - (child.card_size.x/2), destination.y - (child.card_size.y/2))
				child.starting_position = child.position
				child.rotation = rotation_curve.sample(get_hand_ratio(child.get_index())) * 0.3
				child.starting_rotation = child.rotation

func get_card_destination(idx):
	var hand_ratio = get_hand_ratio(idx)
	var destination = Vector2.ZERO
	destination.x += spread_curve.sample(hand_ratio) * 150
	destination.y -= height_curve.sample(hand_ratio) * 20
	return destination

func get_global_card_destination(idx):
	var hand_ratio = get_hand_ratio(idx)
	var destination = Vector2.ZERO
	destination.x += spread_curve.sample(hand_ratio) * 150
	destination.y -= height_curve.sample(hand_ratio) * 20
	return to_global(destination)

func get_hand_ratio(idx):
	var hand_ratio = 0.5
	if get_child_count() > 2:
		hand_ratio = float(idx - 1) / float(get_child_count() -2)
	return hand_ratio

func _process(delta: float) -> void:
	update_hand()
	pass

func add_card(card : Card):
	super.add_card(card)
	EventBus.buses["GameBoardEvents"].emit_signal("card_added_to_hand")
