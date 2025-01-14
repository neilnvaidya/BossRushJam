#Prefab is made to be copied, not used directly in game
extends Boss

@onready var anim_player :AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite
@onready var collider : CollisionShape2D = $CollisionShape2D

func _init():
	super()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_state(new_state):
	super(new_state)
	
func _on_state_tick(state,delta):
	super(state,delta)
	
func _on_state_enter(state):
	super(state)

func _on_state_exit(state):
	super(state)
