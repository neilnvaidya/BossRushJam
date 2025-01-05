# Boss.gb -> Parent Class, Inherited by all boos intances
class_name Boss

extends CharacterBody2D

var state = {
}

var required_state = {
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

var optional_state = {}

func _init(_required_state, _optional_state):
	state = _required_state + optional_state
	
func _ready():
	print(state)
	
func _physics_process(delta):
	pass

func _on_set_state(new_state):
	pass

func _on_state_enter(state):
	pass

func _on_state_exit(state):
	pass
