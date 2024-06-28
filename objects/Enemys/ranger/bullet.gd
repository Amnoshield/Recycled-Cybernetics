extends CharacterBody2D

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var hitbox:Area2D = $hitbox

var speed = 20
var turning_speed_deg = 1
var damage = 2
var knockback = 100

var enemy = true
var self_knockback = Vector2(0, 0)
var knocked_back = false

var rng = RandomNumberGenerator.new()

func _ready():
	rotation = get_ange_to_player()+deg_to_rad(rng.randi_range(-45, 45))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if not knocked_back:
		var vec1 = Vector2(0, 1).rotated(rotation)
		var vec2 = Vector2(0, 1).rotated(get_ange_to_player())
		if vec1.angle_to(vec2) > 0:
			rotation += deg_to_rad(turning_speed_deg)
		else:
			rotation += deg_to_rad(-turning_speed_deg)
		
		velocity = Vector2(0, 1).rotated(rotation)*speed
	elif knocked_back and self_knockback.length() > speed:
		velocity = self_knockback
		self_knockback /= 1.1
	else:
		die()
	
	move_and_slide()


func get_ange_to_player():
	return (player.global_position - global_position).angle()+deg_to_rad(-90)


func take_damage(_damage, fake_knockback:Vector2):
	self_knockback = fake_knockback.normalized()*500
	knocked_back = true
	hitbox.collision_mask = 4
	enemy = false


func _on_hitbox_area_entered(area:Area2D):#hit whatever it is looking at
	if not (enemy and player.parrying):
		die()
	area.take_damage(damage+rng.randi_range(-1, 1), (area.global_position-global_position).normalized()*knockback)
	


func die():
	self.queue_free()


