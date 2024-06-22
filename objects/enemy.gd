extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@export var AI_update_speed = 1
@export var speed = 5


func _ready():
	$"Ai update".start(AI_update_speed)


func _physics_process(delta):
	var global_pos = nav.get_next_path_position()
	var relitive_pos:Vector2 = global_pos-position
	
	print(global_pos, relitive_pos, velocity)
	
	velocity = relitive_pos.limit_length(speed)
	move_and_slide()
	


func make_path(position:Vector2):
	nav.set_target_position(position)


func _on_ai_update_timeout():
	make_path(get_node("../Player").position)
