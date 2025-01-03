extends Node2D


@export var heart:PackedScene

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	if rng.randi_range(1, 10) > 7:
		queue_free()
	else:
		global_position += Vector2(rng.randf_range(-2, 2), rng.randf_range(-2, 2))
		rotation_degrees += rng.randf_range(-5, 5)


func take_damage(damage, _kb):
	if damage:
		$Sprite2D.play("default")
		if Tracker.get_barrel_loot():
			call_deferred("spawn_heart")


func spawn_heart():
	var child:Node2D = heart.instantiate()
	child.global_position = global_position
	$"..".add_child(child)


func _on_sprite_2d_animation_finished() -> void:
	queue_free()
