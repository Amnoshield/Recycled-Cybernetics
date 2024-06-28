extends Area2D

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@export var buffer = 0.2
var enemys:Array = []


func _ready():
	$buffer.wait_time = buffer


func _unhandled_input(event):
	if event.is_action_pressed("parry"):
		if $cooldown.is_stopped():
			parry()
		else:
			$buffer.start()


func parry():
	$AnimationPlayer.play("parry")
	$cooldown.start()


func add_knockback(knockback):
	for area in enemys:
		area.take_damage(0, (area.global_position-global_position).normalized()*knockback)
	enemys.clear()


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		enemys.append(area)


func _on_area_exited(area):
	enemys.erase(area)


func _on_cooldown_timeout():
	if not $buffer.is_stopped():
		parry()
