extends CanvasLayer

@onready var _notification_logger := $NotificationLogger
@onready var _notification_alerts := $NotificationAlerts


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_message(args: String):
	_notification_logger.add_message(args)

func add_alert(args: String):
	_notification_alerts.add_alert(args)
