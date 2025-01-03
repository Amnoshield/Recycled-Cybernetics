extends Node2D


@export var heart:PackedScene


func take_damage(_dmg, _kb):
	$Sprite2D.play("default")



func _on_sprite_2d_animation_finished() -> void:
	var child:Node2D = heart.instantiate()
	child.global_position = global_position
	$"..".add_child(child)
	queue_free()
