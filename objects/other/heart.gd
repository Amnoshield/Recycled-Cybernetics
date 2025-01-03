extends CharacterBody2D


@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]

var rng = RandomNumberGenerator.new()
var turning_speed_deg = 5
var speed = 0.9
var healing = 4
var max_speed = 50

var fake_rotation


func _ready():
	fake_rotation = get_ange_to_player()+deg_to_rad(rng.randi_range(-45, 45))


func _physics_process(_delta):
	var vec1 = Vector2(0, 1).rotated(fake_rotation)
	var vec2 = Vector2(0, 1).rotated(get_ange_to_player())
	if vec1.angle_to(vec2) > 0:
		fake_rotation += deg_to_rad(turning_speed_deg)
	else:
		fake_rotation += deg_to_rad(-turning_speed_deg)
	
	velocity += Vector2(0, 1).rotated(fake_rotation)*speed
	
	if abs(rad_to_deg(velocity.angle_to(vec2))) > 90:
		velocity = velocity.limit_length(max_speed)
	
	move_and_slide()


func get_ange_to_player():
	return (player.global_position - global_position).angle()+deg_to_rad(-90)


func take_damage(damage, _kb):
	if $"spawn cooldown".is_stopped() and damage:
		player.heal(healing)
		self.queue_free()
