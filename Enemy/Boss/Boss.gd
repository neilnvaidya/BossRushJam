# Boss.gb -> Parent Class, Inherited by all boos intances
class_name Boss

extends CharacterBody2D


var state = {
}

var required_states = {
	idle = 0,
	talk = 1,
	move = 2,
	hurt = 3,
	taunt = 4,
	death = 5,
	attack1_phase1 = 6,
	attack_2_phase1 = 7,
	attack1_phase2 = 8,
	attack2_phase2 = 9
}

var optional_states = {}

var current_state

func _init(_required_states = required_states, _optional_states = optional_states):
	print("BOSSS")
	state = _required_states.merged(optional_states)
	current_state = state.idle
	
func _ready():
	print(state)
	
	
func _physics_process(delta):
	_on_state_tick(current_state)

func _on_set_state(new_state):
	if new_state == null or new_state==current_state:
		return
	_on_state_exit(current_state)
	_on_state_enter(new_state)
	current_state = new_state
	
	
func _on_state_tick(state):
	if current_state ==null:
		print("On State Tick - Current State Null")
	

func _on_state_enter(state):
	pass

func _on_state_exit(state):
	pass
