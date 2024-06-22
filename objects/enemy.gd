extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@export var speed = 5
@export var health = 10


func _ready():
	$NavigationAgent2D.max_speed = speed


func _physics_process(_delta):
	nav.set_target_position(get_node("../Player").position)
	var relitive_pos:Vector2 = nav.get_next_path_position()- global_position
	velocity = relitive_pos.normalized()*speed
	move_and_slide()


func take_damage(damage:int):
	print('took damage')
	health -= damage
	if health <= 0:
		self.queue_free()
