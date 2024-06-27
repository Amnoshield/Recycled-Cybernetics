extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_cooldown_timer:Timer = $attack_cooldown
@onready var idle_direction = change_idle_dir()

@export var speed = 80
@export var health = 10
@export var damage = 1
@export var knockback_strenth = 1000
@export var knockback_res = 0
@export var attack_cooldown = 1
@export var idle_speed = 20
@export var wait_distence = 80
@export var wiggle_room = 10
@export var walk_speed = 40


var attack_player = false
var knockback = Vector2(0, 0)
var rng = RandomNumberGenerator.new()


func _ready():
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown


func _physics_process(_delta):
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	health -= oof_damage
	knockback =  new_knockback
	$"State Machine".overide_state("blob_Knockback")
	
	if health <= 0:
		die()


func _on_attack_area_entered(_area):
	attack_player = true
	attack()


func attack():
	if attack_player and attack_cooldown_timer.is_stopped():
		player.take_damage(damage, (player.global_position-global_position).normalized()*knockback_strenth)
		attack_cooldown_timer.start()


func _on_attack_cooldown_timeout():
	attack()


func _on_attack_area_exited(_area):
	attack_player = false # Replace with function body.


func die():
	Tracker.remove_enemy()
	$AnimatedSprite2D/AnimationPlayer.play("die")



func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2



func _on_animation_player_animation_finished(_die): #kill the enemy after death enimation
	queue_free()

