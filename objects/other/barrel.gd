extends RigidBody2D


@export var heart:PackedScene
@export var round_collistion_shape:Shape2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	if rng.randi_range(1, 10) > 7:
		queue_free()
	else:
		if rng.randi_range(0, 1):
			$box.visible = true
			$barrel.visible = false
		else:
			$box.visible = false
			$barrel.visible = true
			$CollisionShape2D.shape = round_collistion_shape
			$Area2D/CollisionShape2D.shape = round_collistion_shape
		
		global_position += Vector2(rng.randf_range(-2, 2), rng.randf_range(-2, 2))
		rotation_degrees += rng.randf_range(-5, 5)


func take_damage(damage, kockback):
	if damage:
		$box.play("default")
		$barrel.play("default")
		if Tracker.get_barrel_loot():
			call_deferred("spawn_heart")
	
	linear_velocity = kockback/2


func spawn_heart():
	var child:Node2D = heart.instantiate()
	child.global_position = global_position
	$"..".add_child(child)


func _on_sprite_2d_animation_finished() -> void:
	queue_free()
