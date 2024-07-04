extends Area2D

@onready var enemy:CharacterBody2D = $".."
#@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		#if not player.attack_ani.is_playing():
		area.take_damage(enemy.damage, (area.global_position-global_position).normalized()*enemy.entity_knockback)
		if is_instance_valid($AudioStreamPlayer):
			$AudioStreamPlayer.play()
		#else:
			#$"../parry".play()
