extends State
class_name p3_d_shoot


@onready var enemy:CharacterBody2D = $"../.."
@onready var bullet:PackedScene = preload("res://objects/Enemys/ranger/bullet.tscn")
@onready var attack_cool = $"../../attack_cooldown"


func Enter():
	fire()
	attack_cool.start()
	Transitioned.emit(self)


func fire():
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = enemy.global_position
	get_node("../../..").add_child(new_bullet)
	enemy.idle_direction = enemy.change_idle_dir()
	Transitioned.emit(self, "p2_d_idle")
