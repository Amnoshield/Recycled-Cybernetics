extends Area2D

@export var damage = 1

func _unhandled_input(_event):
	if Input.is_action_just_pressed("attack_1"):
		#set_rotation(get_local_mouse_position().angle())
		$"../AnimationPlayer".play("sword attack")
		


func _on_area_entered(area):
	print('trying to attack')
	if area.is_in_group("hurtbox"):
		print('attacking')
		area.take_damage(damage)
