extends CharacterBody2D

@onready var health_bar = $Smoothing2D/Sprite2D/HealthBar
@onready var pause_screen:PackedScene = preload("res://Menus/pause/pause_screen.tscn")
@onready var death_screen:PackedScene = preload("res://Menus/death/death_screen.tscn")
@onready var dash_timer = $Dash/cooldown
@onready var parry_timer = $parry/cooldown
@onready var runnin = $runnin
@onready var attack_ani = $"Smoothing2D/sword attack/AnimationPlayer"

@export var invincible = false
@export var parrying = false
@export var dash_speed = 1000
@export var dash_buffer = 0.2

#Exported to tracker
var health
var max_health
var speed
var knockback_res
var dash_cooldown:float = 1.0
var attack_cooldown:float = 1.0
var damage
var entity_knockback
var parry_cooldown:float = 1.0
var damage_res

#normal
var knockback = Vector2(0, 0)
var last_move = Vector2(0, 0)
var dashing_velocity = Vector2(0, 0)
var dashing_frames = 5
var dashing_frame = 0
var control_active = true

@onready var AP = $Smoothing2D/Sprite2D/AnimationPlayer
@onready var sprite = $Smoothing2D/Sprite2D

func _ready():
	download_tracker()
	Tracker.apply_upgrade(self)
	#upload_tracker()
	
	dashing_frame = dashing_frames
	
	$Dash/buffer.wait_time = dash_buffer
	
	set_settings()
	
	if Tracker.current_level_level == 4:
		runnin.stop()
		runnin = $runnin2
		runnin.play()


func set_settings():
	health_bar.max_value = max_health
	health_bar.value = health
	
	dash_timer.wait_time = dash_cooldown
	$"Smoothing2D/sword attack/cooldown".wait_time = attack_cooldown
	$"Smoothing2D/sword attack/CollisionShape2D/progress bar".max_value = attack_cooldown*100
	parry_timer.wait_time = parry_cooldown
	
	$Smoothing2D/Sprite2D/ReferenceRect/dash.setup()
	$Smoothing2D/Sprite2D/ReferenceRect/parry.setup()


func _physics_process(_delta):
	if knockback.length() > speed: #Use knockback
		knockback = knockback.limit_length(knockback.length())
		velocity = knockback
		knockback /= 2
	elif dashing_frame < dashing_frames -1: #Dash
		dashing_frame += 1
		velocity = dashing_velocity
	elif control_active: #Use player movement
		velocity = speed * Input.get_vector("left", "right", "up", "down")
		if velocity.length() and runnin.stream_paused:
			runnin.stream_paused = false
		elif not velocity.length() and not runnin.stream_paused:
			runnin.stream_paused = true
		
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
	if invincible:
		return
	
	if damage_:
		$hurt.play()
	
	damage_ -= damage_res
	if damage_ < 0:
		damage_ = 0
	health -= damage_
	knockback = take_knockback*knockback_res

	health_bar.set_value_no_signal(health)
	if health <= 0:
		call_deferred("die")


func heal(healing):
	health += healing
	health_bar.set_value_no_signal(health)


func _unhandled_key_input(event:InputEvent): #Dash
	if event.is_action_pressed("dash") and control_active:
		if dash_timer.is_stopped():
			dash()
		else:
			$Dash/buffer.start()
	elif event.is_action_pressed("pause") and $"Pause timeout".is_stopped(): #trigger pause
		$"Pause timeout".start()
		var new_pause = pause_screen.instantiate()
		#new_pause.global_position = $Camera2D.get_screen_center_position()
		get_tree().get_nodes_in_group("main level")[0].add_child(new_pause)
		get_tree().paused = true


func dash():
	dashing_frame = 0
	dashing_velocity = last_move.normalized()*dash_speed
	$Dash/AnimationPlayer.play("Dash")
	dash_timer.start()
	$Dash/sound.play()


func _on_cooldown_timeout():
	if not $Dash/buffer.is_stopped():
		dash()


func die():
	var new_death = death_screen.instantiate()
	#new_death.global_position = $Camera2D.get_screen_center_position()
	get_tree().get_nodes_in_group("main level")[0].add_child(new_death)
	get_tree().paused = true
	#get_tree().change_scene_to_file("res://Menus/death_screen.tscn")


func _on_hurtbox_area_entered(_area): #This only sees the finish. Besides that the hurtbox is only used by enemys for damage.
	upload_tracker()
	Tracker.trigger_next_level()


func upload_tracker():
	Tracker.player_max_health = max_health
	Tracker.player_health = health
	Tracker.player_speed = speed
	Tracker.player_knockback_res = knockback_res
	Tracker.player_damage = damage
	Tracker.player_knockback = entity_knockback
	Tracker.player_damage_res = damage_res
	Tracker.player_attack_cooldown = attack_cooldown
	Tracker.player_dash_cooldown = dash_cooldown
	Tracker.player_parry_cooldown = parry_cooldown


func download_tracker():
	health = Tracker.player_health
	max_health = Tracker.player_max_health
	speed = Tracker.player_speed
	knockback_res = Tracker.player_knockback_res
	damage = Tracker.player_damage
	entity_knockback = Tracker.player_knockback
	damage_res = Tracker.player_damage_res
	attack_cooldown = Tracker.player_attack_cooldown
	dash_cooldown = Tracker.player_dash_cooldown
	parry_cooldown = Tracker.player_parry_cooldown


func disable_controls():
	control_active = false
	velocity = Vector2(0, 0)
	dashing_frame = dashing_frames
	knockback = Vector2(0, 0)
	runnin.stream_paused = true


func enable_controls():
	control_active = true
