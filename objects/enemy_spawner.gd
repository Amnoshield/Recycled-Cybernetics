extends Node2D

@export var enemy:PackedScene
var spawnable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Tracker.enemies.append(self)


func spawn():
	var mob:Node = enemy.instantiate()
	mob.global_position = global_position
	get_node("..").add_child(mob)
	self.queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	if spawnable:
		spawn()
