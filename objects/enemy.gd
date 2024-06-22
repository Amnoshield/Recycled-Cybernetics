extends Node2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@export var speed = 5
@export var health = 10


func _ready():
	$NavigationAgent2D.max_speed = speed


func _physics_process(delta):
	nav.set_target_position(get_node("../Player").position)
	var relitive_pos:Vector2 = nav.get_next_path_position()- global_position

	translate(relitive_pos.normalized()*delta*speed)



func _on_area_2d_area_entered(area):
	if area.name == "damager":
		health -= area.damage
		if health <= 0:
			self.queue_free()

