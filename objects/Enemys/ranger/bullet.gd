extends CharacterBody2D

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]

@export var speed = 5
@export var turning_speed_deg = 5

func _ready():
	rotation = (player.global_position -global_position).angle()+deg_to_rad(90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	velocity = Vector2(0, 1)*speed
	move_and_slide()
