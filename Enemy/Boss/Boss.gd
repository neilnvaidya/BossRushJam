# Boss.gb -> Parent Class, Inherited by all boos intances
class_name Boss

extends CharacterBody2D

var current_state

func _init():
	pass
	
func _ready():
	pass
	
func _physics_process(delta):
	_on_state_tick(current_state)

# use _ prefix to indicate overide function
func _set_state(new_state):
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
