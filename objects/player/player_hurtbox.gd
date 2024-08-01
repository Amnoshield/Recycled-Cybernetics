extends Area2D


@onready var player = $".."


func take_damage(damage:int, knockback, parry_sound_node):
	if player.parrying:
		parry_sound_node.play()
		$"../parry/parry ani".play("parry")
		$"../parry".add_knockback(knockback.length())
	else:
		player.take_damage(damage, knockback)
