extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var raycast = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown
@onready var idle_direction = change_idle_dir()
@onready var ap = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var walk_sound = $walk

var speed = 80
var health = 10
var damage = 3
var knockback_strenth = 500
var knockback_res = 0
var attack_cooldown = 1
var wait_distence = 75
var wiggle_room = 10
var walk_speed = 40
var random_attack_min = 0.5
var random_attack_max = 3.5
var idle_speed = 20
const attack_speed = 80

var knockback = Vector2(0, 0)
var attacking_velocity = Vector2(0, 0)
var attacking_frames = 12
var attacking_frame = 0
var rng = RandomNumberGenerator.new()
var dying = false


func _ready():
	download_tracker()
	
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown
	attacking_frame = attacking_frames
	start_rng_attack()


func _process(_delta):
	var face_player = velocity 
	if true:#velocity.length() < speed:
		face_player = player.global_position - global_position
	if velocity == Vector2.ZERO:
		ap.play("idle")
	
	if face_player.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if abs(face_player.x) > abs(face_player.y):
		ap.play("side walk")
	elif face_player.y > 0:
		ap.play("front walk")
	elif face_player.y < 0:
		ap.play("back walk")


func _physics_process(_delta):
	if velocity.length() < speed and not walk_sound.stream_paused:
		walk_sound.stream_paused = true
	elif velocity.length() >= speed and walk_sound.stream_paused:
		walk_sound.stream_paused = false
	
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	if dying:
		return
	
	if oof_damage:
		$hurtbox/AudioStreamPlayer.play()
	
	health -= oof_damage
	knockback =  new_knockback
	attacking_frame = attacking_frames
	$State_Machine.trigger_knockback()
	
	if health <= 0:
		die()


func attack():
	if attack_cooldown_timer.is_stopped():
		attack_cooldown_timer.start()
		if $State_Machine.current_state.name in ["Fighter_Idle", "Fighter_walk_away"]:
			$State_Machine.overide_state("fighterWindup")
			idle_direction = change_idle_dir()
			attacking_velocity = (player.global_position-global_position)*attack_speed/attacking_frames
			attacking_frame = 0
		return true
	return false


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func _on_attack_box_area_entered(area): #this should only apply to the player
	attacking_frame = attacking_frames
	area.take_damage(
		damage+rng.randi_range(-1, 1),
		(area.global_position-global_position).normalized()*knockback_strenth,
		$parry
		)


func die():
	dying = true
	Tracker.remove_enemy(self)
	self.queue_free()


func _on_rng_attack_timeout():
	attack()
	start_rng_attack()


func start_rng_attack():
	$"rng attack".wait_time = rng.randf_range(random_attack_min, random_attack_max)
	$"rng attack".start()


func download_tracker():
	health *= Tracker.enemy_health
	
	attack_cooldown /= Tracker.enemy_attack_cooldown
	random_attack_min /= Tracker.enemy_attack_cooldown
	random_attack_max /= Tracker.enemy_attack_cooldown
	$Sprite2D/dashAP.speed_scale /= Tracker.enemy_attack_cooldown
	
	speed *= Tracker.enemy_speed
	idle_speed *= Tracker.enemy_speed
