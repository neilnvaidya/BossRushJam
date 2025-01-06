extends Boss

func _init():
	optional_states = {optional1 = 10}
	super(required_states, optional_states)
	
	#print("prefab")
	#print(state)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_set_state(new_state):
	super(new_state)
	
	
func _on_state_tick(state):
	super(state)
	

func _on_state_enter(state):
	super(state)

func _on_state_exit(state):
	super(state)
