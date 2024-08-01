extends Area2D

@onready var enemy:CharacterBody2D = $".."


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		area.take_damage(
			enemy.damage,
			(area.global_position-global_position).normalized()*enemy.entity_knockback,
			$"../parry"
			)
		if is_instance_valid($AudioStreamPlayer):
			$AudioStreamPlayer.play()
