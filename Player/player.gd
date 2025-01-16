class_name Player
extends CharacterBody2D


# Dead zone value
const epsilon = 0.05

# Children
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $PlayerSprite
@onready var collision_shape: CollisionShape2D = $PlayerCollisionShape
#@onready var yoyo_handler : YoYoHandler = $YoyoHandler

# GROUP FOR DEBUG PURPOSE
@export_group('Debug Trackers')
@export var current_move_state = move_state.idle
@export var move_dir: Vector2 = Vector2.ZERO
@export var move_input_multiplier : float = 0.0
@export var input_vec: Vector2 = Vector2.ZERO
@export var can_move : bool = true
@export var facing: int = 2
@export var last_nonzero_x: float = 0.0  # To track last meaningful horizontal input



#Balance Variables
@export_group('Balace Variables')
@export var speed_modifier: float = 100.0

#test variables
var test_health = 10
var knock_back_force = 1000

signal announce_position(pos)


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
	#yoyo_handler.handler_setup()
	#yoyo_handler.player_stats = player_stats


func _physics_process(delta):
	handle_input()
	handle_movement(delta)
	handle_collisions(delta)
	announce_position.emit(position)

	
func handle_collisions(_delta: float):
	velocity = move_dir * move_input_multiplier * speed_modifier
	#var col = move_and_slide()
	move_and_slide()
	#if col: print(col.get_collider().name)

func handle_input():
	input_vec = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if abs(move_dir.x) > epsilon:
		last_nonzero_x = move_dir.x


func handle_movement(_delta):
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
	
#knock back function so player can get knock back
func knock_back():
	var knock_back = -velocity.normalized() * knock_back_force
	velocity = knock_back
	move_and_slide()
	
func take_damage():
	#add timer so the game can pause to see the player die
	var timer : Timer = Timer.new()
	self.add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = 3.0
	timer.timeout.connect(_timer_Timeout)
	#test_health can be change into health but leaving for now
	
	test_health = test_health - 1;
	anim_player.play("hurt")
	knock_back()
	print("play hurt ",test_health)
	
	
	#this check to see if the health is 0 or less if it is that it gonna pause 
	#game and play the animation of the player death
	
	if (test_health <= 0):
		print("play die")
		get_tree().paused = true
		can_move = false
		anim_player.play("death")
		timer.start()
		#when die resest the game

#reload the game scene 
func _timer_Timeout():
	print("time done")
	can_move = true
	get_tree().paused = false
	queue_free()
	#Game over screne goes here
	#get_tree().reload_current_scene()
