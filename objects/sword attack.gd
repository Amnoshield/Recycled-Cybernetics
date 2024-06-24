extends Area2D

@export var damage = 1
@export var knockback = 2000
@export var cooldown = 1
@export var buffer = 0.2


func _ready():
	$cooldown.wait_time = cooldown
	$buffer.wait_time = buffer


func _unhandled_input(_event):
	if Input.is_action_just_pressed("attack"):
		if $cooldown.is_stopped():
			attack()
		else:
			$buffer.start()


func attack():
	var mouse_pos = get_global_mouse_position()
	mouse_pos -= global_position
	set_rotation(mouse_pos.angle()+deg_to_rad(90))
	$AnimationPlayer.play("sword attack")
	$cooldown.start()


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		area.take_damage(damage, (area.global_position-global_position).normalized()*knockback)


func _on_cooldown_timeout():
	if not $buffer.is_stopped():
		attack()
