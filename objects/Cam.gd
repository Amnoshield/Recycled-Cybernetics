extends Node2D

@onready var player:CharacterBody2D = get_node("../Player")
@export var dead_zone = 10
@export var deceleration = 5
var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = player.position - position
	if direction.length() > dead_zone:
		velocity = direction.limit_length((direction.length()-dead_zone)/deceleration)
		translate(velocity)
	
