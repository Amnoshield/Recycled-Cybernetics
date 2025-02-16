extends CharacterBody2D


@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@export var ani_timer:Timer
@export var sprite:AnimatedSprite2D

var rng = RandomNumberGenerator.new()
var turning_speed_deg = 5
var speed = 0.9
var healing = 4
var max_speed = 50

var fake_rotation


func _ready():
	fake_rotation = get_ange_to_player()+deg_to_rad(rng.randi_range(-45, 45))
	start_timer()


func _physics_process(_delta):
	var vec1 = Vector2(0, 1).rotated(fake_rotation)
	var vec2 = Vector2(0, 1).rotated(get_ange_to_player())
	if vec1.angle_to(vec2) > 0:
		fake_rotation += deg_to_rad(turning_speed_deg)
	else:
		fake_rotation += deg_to_rad(-turning_speed_deg)
	
	
	velocity += Vector2(0, 1).rotated(fake_rotation)*speed
	
	var leaving_player = abs(rad_to_deg(velocity.angle_to(vec2))) > 90
	var far_from_player = (player.global_position - global_position).length() > 30
	var too_far_from_player = (player.global_position - global_position).length() > 100
	var too_fast = velocity.length() > max_speed
	if leaving_player and far_from_player and too_fast:
		velocity = velocity.limit_length(max_speed)
	if too_far_from_player and not too_fast:
		velocity = (player.global_position - global_position)
	elif too_far_from_player:
		velocity += (player.global_position - global_position)/100
	
	move_and_slide()


func get_ange_to_player():
	return (player.global_position - global_position).angle()+deg_to_rad(-90)


func take_damage(damage, _kb):
	if $"spawn cooldown".is_stopped() and damage:
		player.heal(healing)
		self.queue_free()

func start_timer():
	ani_timer.start(rng.randf_range(1.0, 2.0))


func _on_ani_timer_timeout() -> void:
	start_timer()
	#sprite.flip_h = randi_range(0, 1)
	sprite.play("default")
