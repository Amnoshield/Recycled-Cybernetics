extends Area2D

@export var damage = 1
@export var knockback = 2000

func _unhandled_input(_event):
	if Input.is_action_just_pressed("attack_1"):
		var mouse_pos = get_global_mouse_position()
		mouse_pos -= global_position
		set_rotation(mouse_pos.angle()+deg_to_rad(90))
		$"../AnimationPlayer".play("sword attack")


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		area.take_damage(damage, (area.global_position-global_position).normalized()*knockback)
