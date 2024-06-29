extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var raycast = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown
@onready var random_cooldown_timer = $random_attack_cooldown
@onready var idle_direction = change_idle_dir()

var speed = 80
var health = 10
var damage = 3
var knockback_strenth = 500
var knockback_res = 0
var attack_cooldown = 1
var wait_distence = 75
var wiggle_room = 10
var walk_speed = 40
var random_attack_min = 1
var random_attack_max = 5
var idle_speed = 20

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
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	health -= oof_damage
	knockback =  new_knockback
	attacking_frame = attacking_frames
	$State_Machine.overide_state("Fighter_Knockback")
	
	if health <= 0:
		die()


func attack():
	if attack_cooldown_timer.is_stopped():
		attack_cooldown_timer.start()
		if $State_Machine.current_state.name in ["Fighter_Idle", "Fighter_walk_away"]:
			$State_Machine.overide_state("fighter_attack")
			idle_direction = change_idle_dir()
			$attack_box/AnimationPlayer.play("Attack")
			attacking_velocity = (player.global_position-global_position)*speed/attacking_frames
			attacking_frame = 0
		return true
	return false


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func start_random_attack():
	random_cooldown_timer.start(rng.randi_range(random_attack_min, random_attack_max))


func _on_attack_box_area_entered(area): #this should only apply to the player
	area.take_damage(damage+rng.randi_range(-1, 1), (area.global_position-global_position).normalized()*knockback_strenth)


func _on_random_attack_cooldown_timeout():
	if not raycast.is_colliding() and nav.distance_to_target() < wait_distence+wiggle_room:
		attack()
	start_random_attack()


func die():
	Tracker.remove_enemy(self)
	self.queue_free()

