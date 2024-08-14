extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_cooldown_timer:Timer = $attack_cooldown
@onready var idle_direction = change_idle_dir()
var player_hurt_box


var speed = 80
var health = 5
var damage = 2
var knockback_strenth = 1000
var knockback_res = 0
var attack_cooldown = 1
var idle_speed = 20
var wait_distence = 80
var wiggle_room = 10
var walk_speed = 40


var attack_player = false
var knockback = Vector2(0, 0)
var rng = RandomNumberGenerator.new()
var dying = false


func _ready():
	var hurt_boxs = get_tree().get_nodes_in_group("hurtbox")
	for box in hurt_boxs:
		if box.get_parent().is_in_group("Player"):
			player_hurt_box = box
			break
	
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown


func _physics_process(_delta):
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	if dying:
		return
	
	if oof_damage:
		$hurtbox/AudioStreamPlayer.play()
	else:
		pass
		#$parry.play()
	
	health -= oof_damage
	knockback =  new_knockback
	$"State Machine".trigger_knockback()
	
	if health <= 0:
		die()


func _on_attack_area_entered(_area):
	attack_player = true
	attack()


func attack():
	if attack_player and attack_cooldown_timer.is_stopped():
		player_hurt_box.take_damage(
			damage+rng.randi_range(-1, 1),
			(player.global_position-global_position).normalized()*knockback_strenth,
			$parry
		)
		attack_cooldown_timer.start()


func _on_attack_cooldown_timeout():
	attack()


func _on_attack_area_exited(_area):
	attack_player = false # Replace with function body.


func die():
	dying = true
	$AnimatedSprite2D/AnimationPlayer.play("die")


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func _on_animation_player_animation_finished(_die): #kill the enemy after death enimation
	Tracker.remove_enemy(self)
	queue_free()

