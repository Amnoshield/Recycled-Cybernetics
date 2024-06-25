extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var raycast = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown
@onready var random_cooldown_timer = $random_attack_cooldown
@onready var idle_direction = change_idle_dir()

@export var speed = 80
@export var health = 10
@export var damage = 1
@export var knockback_strenth = 500
@export var knockback_res = 0
@export var attack_cooldown = 1
@export var wait_distence = 100
@export var wiggle_room = 10
@export var walk_speed = 40
@export var random_attack_min = 1
@export var random_attack_max = 5
@export var idle_speed = 20

var knockback = Vector2(0, 0)
var attacking_velocity = Vector2(0, 0)
var attacking_frames = 10
var attacking_frame = 0
var rng = RandomNumberGenerator.new()


func _ready():
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown
	start_random_attack()
	attacking_frame = attacking_frames


func _physics_process(_delta):
	if knockback.length() > speed: #Use knockback
		knockback = knockback.limit_length(knockback.length()-knockback_res)
		velocity = knockback
		knockback /= 2
		
	elif attacking_frame < attacking_frames-1: #Use attack velocity
		attacking_frame += 1
		velocity = attacking_velocity
		
	else: #Use pathfinding
		nav.set_target_position(player.global_position)
		var relitive_pos:Vector2 = nav.get_next_path_position()- global_position
		raycast.target_position = player.global_position-global_position
		raycast.force_raycast_update()
		if  raycast.is_colliding() or nav.distance_to_target() > wait_distence: # pathfind to the player
			velocity = relitive_pos.normalized()*speed
		elif nav.distance_to_target() < wait_distence - wiggle_room: #Walk away from the player
			velocity = (global_position-player.global_position).normalized()*walk_speed
		else: #chill at a good distence from the player
			velocity = ((player.global_position-global_position)-position).rotated(deg_to_rad(90*idle_direction)).normalized()*idle_speed
	
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	health -= oof_damage
	knockback =  new_knockback
	attacking_frame = attacking_frames
	
	if health <= 0:
		die()


func attack():
	if attack_cooldown_timer.is_stopped():
		idle_direction = change_idle_dir()
		$attack_box/AnimationPlayer.play("Attack")
		attacking_velocity = (player.global_position-global_position)*speed/attacking_frames
		attacking_frame = 0
		attack_cooldown_timer.start()
		return true
	return false


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func start_random_attack():
	random_cooldown_timer.start(rng.randi_range(random_attack_min, random_attack_max))


func _on_attack_box_area_entered(area): #this should only apply to the player
	area.take_damage(damage, (area.global_position-global_position).normalized()*knockback_strenth)


func _on_random_attack_cooldown_timeout():
	if not raycast.is_colliding() and nav.distance_to_target() < wait_distence+wiggle_room:
		attack()
	start_random_attack()


func die():
	Tracker.remove_enemy()
	self.queue_free()
