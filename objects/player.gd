extends CharacterBody2D

@export var speed = 5
@export var health = 10
@export var knockback_res = 0
@export var parrying = false

var knockback = Vector2(0, 0)

func _ready():
	$health.set_text(str(health))


func _physics_process(_delta):
	if knockback.length() < speed:
		velocity = speed * Input.get_vector("left", "right", "up", "down")
	else:
		knockback = knockback.limit_length(knockback.length()-knockback_res)
		velocity = knockback
		knockback /= 2
	
	move_and_slide() 


func take_damage(damage:int, take_knockback):
	if parrying:
		$parry.add_knockback()
		return
	
	health -= damage
	knockback = take_knockback

	$health.set_text(str(health))
	if health <= 0:
		self.queue_free()
