extends Area2D


@onready var boss = $".."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var player_hurt_box


func _ready():
	var hurt_boxs = get_tree().get_nodes_in_group("hurtbox")
	for box in hurt_boxs:
		if box.get_parent().is_in_group("Player"):
			player_hurt_box = box
			break


func take_damage(damage:int, knockback, parry_sound_node):
	if boss.parrying:
		boss.parried = true
		parry_sound_node.play()
		$"../player_range/parry ani".play("parry")
		if not player.parrying:
			player_hurt_box.take_damage(
				0,
				(player.global_position-global_position).normalized()*knockback.length(),
				$"../parry"
			)
	else:
		boss.take_damage(damage, knockback)
