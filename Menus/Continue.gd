extends Button

@onready var minimap = get_tree().get_nodes_in_group("minimap")[0]
var hovered = false

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


func _on_draw():
	if is_hovered() and not hovered:
		hovered = true
		$"../../sfx".play()
	elif is_hovered() and hovered:
		$"../../click".play()
	elif not is_hovered() and hovered:
		hovered = false
