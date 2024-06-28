extends Node2D
class_name PartTemplate


var self_idx


func setup(title_:String, sprite:CompressedTexture2D, description_:String, idx:int):
	title(title_)
	part_sprite(sprite)
	description(description_)
	self_idx = idx


func description(description_:String):
	get_children()[3].text = description_

func title(title_:String):
	get_children()[1].text = title_

func part_sprite(sprite:CompressedTexture2D):
	get_children()[2].texture = sprite

func _on_take_pressed():
	Tracker.get_upgrade(self_idx)
