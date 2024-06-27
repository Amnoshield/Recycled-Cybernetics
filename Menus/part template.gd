extends Node2D
class_name PartTemplate


var self_idx


func setup(_title:String, sprite:CompressedTexture2D, _description:String, idx:int):
	title(_title)
	part_sprite(sprite)
	description(_description)
	self_idx = idx


func description(description:String):
	get_children()[3].text = description

func title(title:String):
	get_children()[1].text = title

func part_sprite(sprite:CompressedTexture2D):
	get_children()[2].texture = sprite

func _on_take_pressed():
	Tracker.get_upgrade(self_idx)
