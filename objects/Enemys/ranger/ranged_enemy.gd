extends CharacterBody2D


@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_cooldown_timer = $attack_cooldown
@onready var idle_direction = change_idle_dir()
@onready var ap = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D

var speed = 80
var health = 10
var knockback_strenth = 500
var knockback_res = 0
var attack_cooldown = 1
var wait_distence = 100
var wiggle_room = 10
var walk_speed = 40
var idle_speed = 20

var knockback = Vector2(0, 0)
var rng = RandomNumberGenerator.new()


func _ready():
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown

func _process(_delta):
	rotation = (player.global_position - global_position).angle() + deg_to_rad(-90)
	#var face_player = velocity 
	#if true:#velocity.length() < speed:
		#face_player = player.global_position - global_position
	#if velocity == Vector2.ZERO:
		#ap.play("idle")
	#
	#if face_player.x > 0:
		#sprite.flip_h = true
	#else:
		#sprite.flip_h = false
	#
	#if abs(face_player.x) > abs(face_player.y):
		#ap.play("side")
	#elif face_player.y > 0:
		#ap.play("front")
	#elif face_player.y < 0:
		#ap.play("backs")

func _physics_process(_delta):
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	health -= oof_damage
	knockback =  new_knockback
	$State_Machine.overide_state("ranger_Knockback")
	
	if health <= 0:
		die()


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func die():
	Tracker.remove_enemy(self)
	self.queue_free()
