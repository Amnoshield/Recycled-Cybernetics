extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var raycast = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown
@onready var random_cooldown_timer = $random_attack_cooldown
@onready var idle_direction = change_idle_dir()
@onready var player_attack_animation = get_tree().get_nodes_in_group("attack")[0]
@onready var dash_timer = $dash_cooldown

var knockback_strenth = 500
var knockback = Vector2(0, 0)
var dashing_velocity = Vector2(0, 0)
var dashing_frames = 10
var dashing_frame
var rng = RandomNumberGenerator.new()

#Affected by parts
var health = 20
var max_health = 20
var speed = 100
var knockback_res = 1
var dash_cooldown = 1
var attack_cooldown = 1
var damage = 2
var entity_knockback = 1500
var parry_cooldown = 1
var damage_res = 0


func _ready():
	Tracker.player_reset()
	player.download_tracker()
	player.set_settings()
	Tracker.apply_upgrade(self)
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown
	dash_timer.wait_time = dash_cooldown
	
	dashing_frame = dashing_frames
	
	#player_attack_animation.animation_finished.connect(player_attack) #connect the end of the player's attack


func _physics_process(_delta):
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	oof_damage -= damage_res
	if oof_damage < 0:
		oof_damage = 0
	health -= oof_damage
	knockback =  new_knockback*knockback_res
	#dashing_frame = dashing_frames #This sould be used at the end of the dashing / attacking state
	$State_Machine.overide_state("p2_Knockback")
	
	if health <= 0:
		die()


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func start_random_attack():
	random_cooldown_timer.start(rng.randi_range(2, 5))


func die():
	Tracker.remove_enemy(self)
	self.queue_free()

