extends Node
class_name State_Machine

@export var initial_state:State

var current_state:State
var states = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
		else:
			print("unknown child in state")
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	else:
		print("No starting state selected")

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print("State \"", new_state_name, "\" does not exist")
		return
		
	if current_state:
		current_state.Exit()
	
	current_state = new_state
	new_state.Enter()


func overide_state(new_state_name):
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print("State \"", new_state_name, "\" does not exist")
		return
		
	if current_state:
		current_state.Exit()
	
	current_state = new_state
	new_state.Enter()

