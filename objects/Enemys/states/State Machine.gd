extends Node
class_name State_Machine

@export var initial_state:State

var next_state
var current_state:State
var states = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			child.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			print("unknown child in state")
	
	if initial_state:
		initial_state.process_mode = Node.PROCESS_MODE_INHERIT
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

func on_child_transition(state, new_state_name = null):
	if state != current_state:
		return
	
	if not new_state_name:
		new_state_name = next_state
	
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print("State \"", new_state_name, "\" does not exist")
		return
		
	if current_state:
		current_state.Exit()
		current_state.process_mode = Node.PROCESS_MODE_DISABLED
		
	
	new_state.process_mode = Node.PROCESS_MODE_INHERIT
	current_state = new_state
	new_state.Enter()


func overide_state(new_state_name, continue_after = true, exit = true):
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		print("State \"", new_state_name, "\" does not exist")
		return
		
	if exit and current_state:
		current_state.Exit()
	
	if current_state:
		current_state.process_mode = Node.PROCESS_MODE_DISABLED		
	
	if continue_after:
		next_state = current_state.name.to_lower()
	
	new_state.process_mode = Node.PROCESS_MODE_INHERIT
	current_state = new_state
	new_state.Enter()
