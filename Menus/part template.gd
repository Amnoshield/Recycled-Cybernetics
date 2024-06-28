extends Node2D
class_name PartTemplate


var self_idx


func setup(title_:String, sprite:CompressedTexture2D, description_:String, background_sprite_:CompressedTexture2D, idx:int):
	title(title_)
	part_sprite(sprite)
	description(description_)
	if background_sprite_:
		background_sprite(background_sprite_)
	self_idx = idx


func description(description_:String):
	get_children()[3].text = description_

func title(title_:String):
	get_children()[1].text = title_
	get_children()[1].tooltip_text = title_

func part_sprite(sprite:CompressedTexture2D):
	get_children()[2].texture = sprite

func background_sprite(sprite:CompressedTexture2D):
	get_children()[0].texture = sprite

func _on_take_pressed():
	Tracker.get_upgrade(self_idx)
