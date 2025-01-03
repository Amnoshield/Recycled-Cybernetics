extends Node2D


@export var heart:PackedScene


func take_damage(_dmg, _kb):
	call_deferred("trigger")


func trigger():
	var child:Node2D = heart.instantiate()
	child.global_position = global_position
	$"..".add_child(child)
	queue_free()
