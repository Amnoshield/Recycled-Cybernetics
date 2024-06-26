extends State
class_name Fighter_Idle

@onready var enemy:CharacterBody2D = $"../.."


func Physics_Update(_delta):
	enemy.velocity = Vector2(0, 0)
