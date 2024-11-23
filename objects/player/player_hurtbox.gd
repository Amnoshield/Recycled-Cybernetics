extends Area2D


@onready var player = $".."


func take_damage(damage:int, knockback, parry_sound_node):
	if player.parrying:
		parry_sound_node.play()
		call_deferred("trigger_parry_ani")
		$"../parry".add_knockback(knockback.length())
	else:
		player.take_damage(damage, knockback)


func trigger_parry_ani():
	$"../parry/parry ani".play("parry")
