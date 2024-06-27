extends Button

@onready var minimap = get_tree().get_nodes_in_group("minimap")[0]


func _ready():
	minimap.invis()

func _on_pressed():
	unpause()

func _unhandled_key_input(event:InputEvent):
	if event.is_action_pressed("pause"):
		unpause()
		
func unpause():
	minimap.vis()
	get_tree().paused = false
	$"../..".queue_free()
