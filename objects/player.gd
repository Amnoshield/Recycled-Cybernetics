extends CharacterBody2D

@export var speed = 100
@export var health = 10
@export var knockback_res = 0
@export var invincible = false
@export var parrying = false
@export var dash_speed = 1000

var knockback = Vector2(0, 0)
var last_move = Vector2(0, 0)
var dashing_velocity = Vector2(0, 0)
var dashing_frames = 5
var dashing_frame = 0

func _ready():
	$Smoothing2D/Sprite2D/health.set_text(str(health))
	dashing_frame = dashing_frames


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
		if velocity.length() != 0:
			last_move = velocity
	
	move_and_slide()


func take_damage(damage:int, take_knockback:Vector2):
	if parrying:
		$parry.add_knockback(take_knockback.length())
		return
	
	elif invincible:
		return
	
	health -= damage
	knockback = take_knockback

	$Smoothing2D/Sprite2D/health.set_text(str(health))
	if health <= 0:
		get_tree().change_scene_to_file("res://levels/death_screen.tscn")

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("dash"):
		dashing_frame = 0
		dashing_velocity = last_move.normalized()*dash_speed
		$Dash.play("Dash")
