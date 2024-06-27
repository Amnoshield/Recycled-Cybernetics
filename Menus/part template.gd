extends Node2D


var self_idx
var self_buff


func setup(title:String, sprite:CompressedTexture2D, description:String, idx:int, buff:bool):
	title(title)
	part_sprite(sprite)
	description(description)
	self_idx = idx
	self_buff = buff


func description(description:String):
	$Description.text = description


func title(title:String):
	$Title.text = title


func part_sprite(sprite:CompressedTexture2D):
	$"part sprite".texture = sprite


func _on_take_pressed():
	Tracker.get_upgrade(self_idx, self_buff)
