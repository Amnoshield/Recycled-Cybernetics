extends Area2D

@export var buffer = 0.2
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]


func _ready():
	$buffer.wait_time = buffer


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
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
		area.take_damage(player.damage, (area.global_position-global_position).normalized()*player.player_knockback)


func _on_cooldown_timeout():
	if not $buffer.is_stopped():
		attack()
