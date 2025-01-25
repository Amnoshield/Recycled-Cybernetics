extends Node2D

@export var boss_phase1:Node2D
@export var boss_phase2:Node2D
@export var boss_phase3:Node2D
@export var minions:Node2D
@export var player_point:Node2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var triggered = false
var phase = 1


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if not triggered:
		Tracker.num_enemies += 4
		triggered = true
		player.disable_controls()
		player.global_position = player_point.global_position
		$Timing.play("main_events")


func next_phase():
	match phase:
		1:
			boss_phase2.global_position = boss_phase1.global_position
			boss_phase1.queue_free()
			boss_phase2.visible = true
			boss_phase2.set_process_mode(Node.PROCESS_MODE_PAUSABLE)
		2:
			boss_phase3.global_position = boss_phase2.global_position
			boss_phase2.queue_free()
			boss_phase3.visible = true
			boss_phase3.set_process_mode(Node.PROCESS_MODE_PAUSABLE)
		_:
			push_error("This should not be reachable")
	
	phase += 1


func activate_boss():
	print("activating boss")
	boss_phase1.set_process_mode(Node.PROCESS_MODE_PAUSABLE)
	minions.set_process_mode(Node.PROCESS_MODE_PAUSABLE)
	player.enable_controls()


func zoom_out_cam():
	player.find_children("cam_zoom")[0].play("zoom_out")
