class_name Player
extends CharacterBody2D


@export var player_stats : PlayerStats


# Dead zone value
const epsilon = 0.05

# Children
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $PlayerSprite
@onready var collision_shape: CollisionShape2D = $PlayerCollisionShape



# GROUP FOR DEBUG PURPOSE
@export_group('Debug Trackers')
@export var current_move_state = move_state.idle
@export var move_dir: Vector2 = Vector2.ZERO
@export var move_input_multiplier : float = 0.0
@export var input_vec: Vector2 = Vector2.ZERO
@export var can_move : bool = true
@export var facing: int = 1
@export var last_nonzero_x: float = 0.0  # To track last meaningful horizontal input

#Balance Variables
@export_group('Balace Variables')
@export var speed_modifier: float = 100.0

# Enum for movement, may be joined to greater state machine later.
enum move_state {
	idle,
	left,
	right,
	up,
	down_left,
	down_right
}

func _ready():
	anim_player.play("idle")
	###########################
	# TODO:
	# This should all be inside the yoyo handler not in palyer
	# Yoyo handler needs to self initialise a resource as default for safety
	# the positioning doesnt work if we load the player off the origin, 
	# this means that the position calculations are not effective

	#################
	# TODO ENDS
	

func _physics_process(delta):
	handle_input()
	handle_movement(delta)
	handle_collisions(delta)
	

		

	
func handle_collisions(delta: float):
	var col = move_and_collide(move_dir * move_input_multiplier * speed_modifier * delta)
	if col: print(col.get_collider().name)

func handle_input():
	input_vec = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if abs(move_dir.x) > epsilon:
		last_nonzero_x = move_dir.x


func handle_movement(delta):
	if !can_move : 
		# Zero out movement
		move_dir = Vector2.ZERO
		move_input_multiplier = 0.0
		return
	
	# Set movement vars from input
	move_dir = input_vec.normalized()
	move_input_multiplier = input_vec.length()
	
	# If stationary
	if near_zero_v(move_dir):
		set_state(move_state.idle)
	else:
		# Motion is split into quadrants at 45 derees to cardinal
		# If left right movement
		if moving_sideways():
			set_state(move_state.right if facing > 0 else move_state.left)
		else:
			# if Up movement
			if moving_upwards():
				set_state(move_state.up)
			else:
				# Down movement
				set_state(move_state.down_right if facing > 0 else move_state.down_left)

func set_facing():
	if abs(move_dir.x) > epsilon:
		facing = 1 if last_nonzero_x > 0 else -1

func moving_sideways() -> bool:
	return abs(move_dir.x) >= abs(move_dir.y)

func moving_upwards() -> bool:
	return move_dir.y < 0

func near_zero_v(vec: Vector2) -> bool:
	return vec.length() < epsilon

func near_zero_f(val: float) -> bool:
	return abs(val) < epsilon

func set_state(new_state):
	set_facing()
	if new_state == current_move_state:
		return

	if new_state == move_state.right or new_state == move_state.down_right:
		anim_player.play("right")

	elif new_state == move_state.left or new_state == move_state.down_left:
		anim_player.play("left")
		

	elif new_state == move_state.idle:
		anim_player.play("idle")
		# Preserve the last facing direction when idle
		$PlayerSprite.flip_h = (facing == -1)

	elif new_state == move_state.up:
		anim_player.play("up")

	current_move_state = new_state
