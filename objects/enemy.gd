extends Node2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@export var AI_update_speed = 1

func _ready():
	$"Ai update".wait_time = AI_update_speed

func _physics_process(delta):
	nav.get_next_path_position()


func make_path(position:Vector2):
	nav.set_target_position(position)

func _on_ai_update_timeout():
	#make_path()
