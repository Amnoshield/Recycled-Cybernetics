extends Area2D

@export var damage = 0
@export var cooldown = 1
@export var buffer = 0.2
var enemys:Array = []


func _ready():
	$cooldown.wait_time = cooldown
	$buffer.wait_time = buffer


func _unhandled_input(_event):
	if Input.is_action_just_pressed("parry"):
		if $cooldown.is_stopped():
			parry()
		else:
			$buffer.start()


func parry():
	$AnimationPlayer.play("parry")
	$cooldown.start()


func add_knockback(knockback):
	for area in enemys:
		area.take_damage(damage, (area.global_position-global_position).normalized()*knockback)
	enemys.clear()


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		enemys.append(area)


func _on_area_exited(area):
	enemys.erase(area)


func _on_cooldown_timeout():
	if not $buffer.is_stopped():
		parry()
