extends CharacterBody2D

@onready var health_bar = $Smoothing2D/Sprite2D/HealthBar

@export var speed = 100
@export var knockback_res = 0
@export var invincible = false
@export var parrying = false
@export var dash_speed = 1000
@export var dash_cooldown = 1
@export var dash_buffer = 0.2

var knockback = Vector2(0, 0)
var last_move = Vector2(0, 0)
var dashing_velocity = Vector2(0, 0)
var dashing_frames = 5
var dashing_frame = 0

@onready var AP = $Smoothing2D/Sprite2D/AnimationPlayer
@onready var sprite = $Smoothing2D/Sprite2D

func _ready():
	health_bar.set_value_no_signal(Tracker.player_health)
	health_bar.max_value = Tracker.player_max_health
	dashing_frame = dashing_frames
	$Dash/cooldown.wait_time = dash_cooldown
	$Dash/buffer.wait_time = dash_buffer


func _physics_process(_delta):
	if knockback.length() > speed: #Use knockback
		knockback = knockback.limit_length(knockback.length()-knockback_res)
		velocity = knockback
		knockback /= 2
	elif dashing_frame < dashing_frames -1: #Dash
		dashing_frame += 1
		velocity = dashing_velocity
	else: #Use player movement
		velocity = speed * Input.get_vector("left", "right", "up", "down")
		
		if velocity.y > 0 and velocity.x == 0:
			AP.play("walk forward")
		if velocity.y < 0 and velocity.x == 0:
			AP.play("walk backward")
		if velocity.x < 0 and velocity.y == 0:
			AP.play("walk sideways")
			AP.play("walk sideways")
		print(last_move)
	move_and_slide()


func take_damage(damage:int, take_knockback:Vector2):
	if parrying:
		$parry.add_knockback(take_knockback.length())
		return
	
	elif invincible:
		return
	
	Tracker.player_health -= damage
	knockback = take_knockback

	health_bar.set_value_no_signal(Tracker.player_health)
	if Tracker.player_health <= 0:
		die()


func _unhandled_key_input(_event): #Dash
	if Input.is_action_just_pressed("dash"):
		if $Dash/cooldown.is_stopped():
			dash()
		else:
			$Dash/buffer.start()


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
	Tracker.trigger_next_level()

