extends CharacterBody2D


@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_cooldown_timer = $attack_cooldown
@onready var idle_direction = change_idle_dir()

@export var speed = 80
@export var health = 5
@export var damage = 1
@export var knockback_strenth = 500
@export var knockback_res = 0
@export var attack_cooldown = 1
@export var wait_distence = 75
@export var wiggle_room = 10
@export var walk_speed = 40
@export var idle_speed = 20

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
	$State_Machine.overide_state("ranger_Knockback")
	
	if health <= 0:
		die()


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func die():
	Tracker.remove_enemy()
	self.queue_free()
