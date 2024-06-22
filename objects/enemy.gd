extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@export var AI_update_speed = 1
@export var speed = 5


func _ready():
	$NavigationAgent2D.max_speed = speed
	$"Ai update".start(AI_update_speed)
	_on_ai_update_timeout()


func _physics_process(_delta):
	var relitive_pos:Vector2 = nav.get_next_path_position()- global_position

	
	velocity = relitive_pos.limit_length(speed)
	move_and_slide()


func make_path(_position:Vector2):
	nav.set_target_position(_position)


func _on_ai_update_timeout():
	make_path(get_node("../Player").position)
