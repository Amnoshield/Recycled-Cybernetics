extends CharacterBody2D

@onready var health_bar = $Smoothing2D/Sprite2D/HealthBar
@onready var pause_screen:PackedScene = preload("res://Menus/pause_screen.tscn")

@export var invincible = false
@export var parrying = false
@export var dash_speed = 1000
@export var dash_buffer = 0.2

#Exported to tracker
var health
var max_health
var speed
var knockback_res
var dash_cooldown
var attack_cooldown
var damage
var entity_knockback
var parry_cooldown
var damage_res

#normal
var knockback = Vector2(0, 0)
var last_move = Vector2(0, 0)
var dashing_velocity = Vector2(0, 0)
var dashing_frames = 5
var dashing_frame = 0

@onready var AP = $Smoothing2D/Sprite2D/AnimationPlayer
@onready var sprite = $Smoothing2D/Sprite2D

func _ready():
	download_tracker()
	Tracker.apply_upgrade()
	health_bar.max_value = max_health
	health_bar.value = health

	dashing_frame = dashing_frames
	$Dash/cooldown.wait_time = dash_cooldown
	$Dash/buffer.wait_time = dash_buffer
	
	$"Smoothing2D/sword attack/cooldown".wait_time = attack_cooldown
	$parry/cooldown.wait_time = parry_cooldown


func _physics_process(_delta):
	if knockback.length() > speed: #Use knockback
		knockback = knockback.limit_length(knockback.length())
		velocity = knockback
		knockback /= 2
	elif dashing_frame < dashing_frames -1: #Dash
		dashing_frame += 1
		velocity = dashing_velocity
	else: #Use player movement
		velocity = speed * Input.get_vector("left", "right", "up", "down")
		
		#walk animations
		if velocity.y > 0 and velocity.x == 0:
			sprite.flip_h = false
			AP.play("walk forward")
		if velocity.y < 0 and velocity.x == 0:
			sprite.flip_h = false
			AP.play("walk backward")
		if velocity.x < 0 and velocity.y == 0:
			sprite.flip_h = false
			AP.play("walk sideways")
		if velocity.x > 0 and velocity.y == 0:
			sprite.flip_h = true
			AP.play("walk sideways")
		if velocity.x < 0 and velocity.y > 0:
			sprite.flip_h = false
			AP.play("walk down diag")
		if velocity.x > 0 and velocity.y > 0:
			sprite.flip_h = true
			AP.play("walk down diag")
		if velocity.x < 0 and velocity.y < 0:
			sprite.flip_h = false
			AP.play("walk up diag")
		if velocity.x > 0 and velocity.y < 0:
			sprite.flip_h = true
			AP.play("walk up diag")
		
		if velocity.length() != 0:
			last_move = velocity
	
	if velocity == Vector2.ZERO: #Idle animations
		if last_move == Vector2(0 ,-100):
			sprite.flip_h = false
			AP.play("idle back")
		elif  last_move == Vector2(0 ,100):
			sprite.flip_h = false
			AP.play("idle front")
		elif  last_move.x > 0:
			sprite.flip_h = true
			AP.play("idle side")
		elif  last_move.x < 0:
			sprite.flip_h = false
			AP.play("idle side")
	
	move_and_slide()


func take_damage(damage_:int, take_knockback:Vector2):
	if parrying:
		$parry.add_knockback(take_knockback.length())
		return
	
	elif invincible:
		return
	
	damage_ -= damage_res
	if damage_ < 0:
		damage_ = 0
	health -= damage_
	knockback = take_knockback*knockback_res

	health_bar.set_value_no_signal(health)
	if health <= 0:
		die()


func _unhandled_key_input(event:InputEvent): #Dash
	if event.is_action_pressed("dash"):
		if $Dash/cooldown.is_stopped():
			dash()
		else:
			$Dash/buffer.start()
	elif event.is_action_pressed("pause") and $"Pause timeout".is_stopped(): #trigger pause
		$"Pause timeout".start()
		var new_pause = pause_screen.instantiate()
		new_pause.global_position = global_position
		get_tree().get_nodes_in_group("main level")[0].add_child(new_pause)
		get_tree().paused = true


func dash():
	dashing_frame = 0
	dashing_velocity = last_move.normalized()*dash_speed
	$Dash/AnimationPlayer.play("Dash")
	$Dash/cooldown.start()


func _on_cooldown_timeout():
	if not $Dash/buffer.is_stopped():
		dash()


func die():
	get_tree().change_scene_to_file("res://Menus/death_screen.tscn")


func _on_hurtbox_area_entered(_area): #This only sees the finish. Besides that the hurtbox is only used by enemys for damage.
	upload_tracker()
	Tracker.trigger_next_level()


func upload_tracker():
	Tracker.player_max_health = max_health
	Tracker.player_health = health
	Tracker.player_speed = speed
	Tracker.player_knockback_res = knockback_res
	Tracker.player_dash_cooldown = dash_cooldown
	Tracker.player_attack_cooldown = attack_cooldown
	Tracker.player_damage = damage
	Tracker.player_knockback = entity_knockback
	Tracker.player_parry_cooldown = parry_cooldown
	Tracker.player_damage_res = damage_res


func download_tracker():
	health = Tracker.player_health
	max_health = Tracker.player_max_health
	speed = Tracker.player_speed
	knockback_res = Tracker.player_knockback_res
	dash_cooldown = Tracker.player_dash_cooldown
	attack_cooldown = Tracker.player_attack_cooldown
	damage = Tracker.player_damage
	entity_knockback = Tracker.player_knockback
	parry_cooldown = Tracker.player_parry_cooldown
	damage_res = Tracker.player_damage_res
