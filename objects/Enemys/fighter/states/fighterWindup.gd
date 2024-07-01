extends State
class_name fighterWindup

@onready var dashAP = $"../../Sprite2D/dashAP"

func Enter():
	dashAP.play("dash")


func _on_dash_ap_animation_finished(_anim_name):
	Transitioned.emit(self, "fighter_attack")
