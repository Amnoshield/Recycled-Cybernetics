extends State
class_name fighterWindup

@onready var dashAP = $"../../Sprite2D/dashAP"
@onready var enemy:CharacterBody2D = $"../.."


func Enter():
	enemy.velocity = Vector2(0, 0)
	dashAP.play("dash")


func _on_dash_ap_animation_finished(_anim_name):
	Transitioned.emit(self, "fighter_attack")


func Knockback_Event():
	pass
