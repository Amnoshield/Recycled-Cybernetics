extends Sprite2D


@export var level:int

# Called when the node enters the scene tree for the first time.
func _ready():
	if Tracker.current_level_level == level:
		scale = Vector2(2, 2)
