extends State
class_name Blob_Idle

@onready var enemy:CharacterBody2D = $"../.."
@onready var attack_cooldown:Timer = $"../../attack_cooldown"

func Physics_Update(_delta):
	enemy.velocity = Vector2(0, 0)
	if attack_cooldown.is_stopped():
		Transitioned.emit(self, "Blob_pathfind")
