extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_node("../Player")
@onready var raycast = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown

@export var speed = 80
@export var health = 10
@export var damage = 1
@export var knockback_strenth = 1000
@export var knockback_res = 0
@export var attack_cooldown = 1
@export var wait_distence = 100
@export var wiggle_room = 10
@export var walk_speed = 40

var knockback = Vector2(0, 0)


func _ready():
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown


func _physics_process(_delta):
	if knockback.length() < speed:
		nav.set_target_position(player.position)
		var relitive_pos:Vector2 = nav.get_next_path_position()- global_position
		raycast.target_position = player.position-global_position
		raycast.force_raycast_update()
		if  raycast.is_colliding() or nav.distance_to_target() > wait_distence:
			velocity = relitive_pos.normalized()*speed
		elif nav.distance_to_target() < wait_distence - wiggle_room:
			attack()
			#velocity = (global_position-player.position).normalized()*walk_speed
		else:
			velocity = Vector2(0, 0)
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


func attack():
	if attack_cooldown_timer.is_stopped():
		$attack_box/AnimationPlayer.play("Attack")
		knockback = (player.position-global_position).normalized()*1000
		#player.take_damage(damage, (player.global_position-global_position).normalized()*knockback_strenth)
		attack_cooldown_timer.start()
