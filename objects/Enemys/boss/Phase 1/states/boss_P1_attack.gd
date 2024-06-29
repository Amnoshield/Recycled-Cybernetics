extends State
class_name boss_P1_attack

@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_ani = $"../../attack_box/AnimationPlayer"

func _ready():
	attack_ani.animation_finished.connect(finish_attack)	


func Enter():
	enemy.attack_cooldown_timer.start()
	enemy.idle_direction = enemy.change_idle_dir()
	attack_ani.play("Attack")


func finish_attack(_i_dont_care):
	if $"..".current_state.name in ["boss_P1_dash_attack"]:
		Transitioned.emit(self, "boss_P1_Idle")

