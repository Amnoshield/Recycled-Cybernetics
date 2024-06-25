extends Node2D

@onready var ray = $RayCast2D
@export var enemy:PackedScene
var spawnable = false
var near_spawners = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Tracker.num_enemies += 1
	Tracker.enemies.append(self)


func spawn():
	if not spawnable:
		return
	var mob:Node = enemy.instantiate()
	mob.global_position = global_position
	get_node("..").add_child(mob)
	spawnable = false
	trigger()
	self.queue_free()


func trigger():
	for spawner in near_spawners:
		spawner.spawn()


func _on_visible_on_screen_notifier_2d_screen_entered():
	spawn()


func _on_area_2d_area_entered(area:Area2D):
	ray.target_position = area.global_position - global_position
	if not ray.is_colliding():
		near_spawners.append(area.get_parent())
