extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var raycast = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown
@onready var random_cooldown_timer = $random_attack_cooldown
@onready var idle_direction = change_idle_dir()
@onready var player_attack_animation = get_tree().get_nodes_in_group("attack")[0]
@onready var dash_timer = $dash_cooldown
@onready var parry_timer = $player_range/parry_cooldown
@onready var minion = preload("res://objects/Enemys/fighter/fighter_enemy.tscn")
@onready var walk_sound = $walk

var knockback_strenth = 500
var knockback = Vector2(0, 0)
var dashing_velocity = Vector2(0, 0)
var dashing_frames = 10
var dashing_frame
var rng = RandomNumberGenerator.new()
var parrying = false
var parried = false
var invincible = false
var state

#Affected by parts
var health = 10
var max_health = 10
var speed = 100
var knockback_res = 1
var dash_cooldown = 2.0
var attack_cooldown = 2.0
var damage = 5
var entity_knockback = 1500
var parry_cooldown = 2.0
var damage_res = 1


func _ready():
	Tracker.player_reset()
	player.download_tracker()
	player.set_settings()
	Tracker.apply_upgrades(self)
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown
	dash_timer.wait_time = dash_cooldown
	parry_timer.wait_time = parry_cooldown
	
	dashing_frame = dashing_frames
	
	spawn_minions()


func spawn_minions():
	for x in range(2):
		Tracker.num_enemies += 1
		var mob:Node = minion.instantiate()
		mob.global_position = global_position+Vector2(rng.randi_range(-10, 10), rng.randi_range(-10, 10))
		get_node("..").add_child(mob)
	Tracker.enemy_counter.change_label(Tracker.num_enemies)


func _physics_process(_delta):
	if velocity.length() < speed and not walk_sound.stream_paused:
		walk_sound.stream_paused = true
	elif velocity.length() >= speed and walk_sound.stream_paused:
		walk_sound.stream_paused = false
	
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	if invincible:
		return
	
	if oof_damage:
		$hurt.play()
	else:
		$parry.play()
	
	oof_damage -= damage_res
	if oof_damage < 0:
		oof_damage = 0
	health -= oof_damage
	knockback =  new_knockback*knockback_res
	dashing_frame = dashing_frames #This sould be used at the end of the dashing / attacking state
	$State_Machine.trigger_knockback()
	
	if health <= 0:
		call_deferred("die")


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func start_random_attack():
	random_cooldown_timer.start(rng.randi_range(2, 5))


func die():
	Tracker.remove_enemy(self)
	self.queue_free()


func _on_parry_deration_timeout():
	parrying = false


func download_tracker():
	health *= Tracker.enemy_health
	max_health *= Tracker.enemy_health
	
	attack_cooldown /= Tracker.enemy_attack_cooldown
	dash_cooldown /= Tracker.enemy_attack_cooldown
	attack_cooldown /= Tracker.enemy_attack_cooldown
	parry_cooldown /= Tracker.enemy_attack_cooldown
	$"State_Machine/big attack".speed_scale /= Tracker.enemy_attack_cooldown
	$"State_Machine/dash attack windup".speed_scale /= Tracker.enemy_attack_cooldown
	
	speed *= Tracker.enemy_speed
