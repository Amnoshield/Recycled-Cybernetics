extends CharacterBody2D

@export var speed = 5
@export var health = 10


func _physics_process(delta):
	get_move_input(delta)
	move_and_slide() 


func get_move_input(_delta):
	velocity = speed * Input.get_vector("left", "right", "up", "down")


func take_damage(damage:int, knockback):
	health -= damage
	velocity = knockback
	move_and_slide()
	
	if health <= 0:
		self.queue_free()
