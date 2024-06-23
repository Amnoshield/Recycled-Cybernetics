extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_node("../Player")
@export var speed = 5
@export var health = 10
@export var damage = 1
@export var knockback_strenth = 1000
@export var knockback_res = 0
var knockback = Vector2(0, 0)


func _ready():
	$NavigationAgent2D.max_speed = speed


func _physics_process(_delta):
	if knockback.length() < speed:
		nav.set_target_position(player.position)
		var relitive_pos:Vector2 = nav.get_next_path_position()- global_position
		velocity = relitive_pos.normalized()*speed
	else:
		knockback = knockback.limit_length(knockback.length()-knockback_res)
		velocity = knockback
		knockback /= 2
	
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	health -= oof_damage
	knockback =  new_knockback
	
	if health <= 0:
		self.queue_free()


func _on_attack_area_entered(area):
	area.take_damage(damage, (area.global_position-global_position).normalized()*knockback_strenth)
