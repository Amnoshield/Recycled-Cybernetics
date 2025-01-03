extends CharacterBody2D


@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_cooldown_timer = $attack_cooldown
@onready var idle_direction = change_idle_dir()
@onready var sprite = $Sprite2D
@onready var walk_sound = $walk

var speed = 80.0
var health = 8
var knockback_strenth = 500
var knockback_res = 0
var attack_cooldown = 1
var wait_distence = 100
var wiggle_room = 10
var walk_speed = 40
var idle_speed = 20

var knockback = Vector2(0, 0)
var rng = RandomNumberGenerator.new()
var dying = false


func _ready():
	download_tracker()
	
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown

func _process(_delta):
	rotation = (player.global_position - global_position).angle() + deg_to_rad(-90)


func _physics_process(_delta):
	if velocity.length() < speed/3 and not walk_sound.stream_paused:
		walk_sound.stream_paused = true
	elif velocity.length() >= speed/3 and walk_sound.stream_paused:
		walk_sound.stream_paused = false
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	if dying:
		return
	
	if oof_damage:
		$hurtbox/hurt.play()
	
	health -= oof_damage
	knockback =  new_knockback
	$State_Machine.trigger_knockback()
	
	if health <= 0:
		die()


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func die():
	dying = true
	Tracker.remove_enemy(self)
	self.queue_free()


func download_tracker():
	health *= Tracker.enemy_health
	attack_cooldown /= Tracker.enemy_attack_cooldown
	speed *= Tracker.enemy_speed
	walk_speed *= Tracker.enemy_speed
