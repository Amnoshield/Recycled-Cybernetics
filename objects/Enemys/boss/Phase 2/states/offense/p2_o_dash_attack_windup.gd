extends State
class_name p2_o_dash_attack


@onready var enemy:CharacterBody2D = $"../.."


func Enter():
	$"../dash attack windup".play("windup")
	enemy.velocity = Vector2(0, 0)


func _on_dash_attack_windup_animation_finished(_anim_name):
	Transitioned.emit(self, "p2_o_dash1")

func Knockback_Event():
	pass
