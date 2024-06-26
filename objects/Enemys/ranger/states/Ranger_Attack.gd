extends State
class_name Ranger_Attack

@onready var enemy:CharacterBody2D = $"../.."
@onready var bullet:PackedScene = preload("res://objects/Enemys/ranger/bullet.tscn")
@onready var attack_cooldown:Timer = $"../../attack_cooldown"


func Enter():
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = enemy.global_position
	get_node("../../..").add_child(new_bullet)
	attack_cooldown.start()
	enemy.idle_direction = enemy.change_idle_dir()
	Transitioned.emit(self, "Ranger_Idle")


