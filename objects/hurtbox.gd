extends Area2D


@onready var player = $".."


func take_damage(damage:int, knockback, _null_sound = null):
	$"..".take_damage(damage, knockback)
