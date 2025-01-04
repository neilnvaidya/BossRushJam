extends CharacterBody2D
const ARC_POINTS := 10

# chidren
@onready var anim_player :AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $PlayerSprite
@onready var collision_shape :CollisionShape2D = $PlayerCollisionShape
@onready var flail = $Flail
@onready var string = $CanvasLayer/String

# movement Trackers
@export var move_dir : Vector2 = Vector2.ZERO
@export var move_speed : float =100.0
const epsilon = 0.05
var facing : int = 0

enum move_state {
	idle,
	left,
	right,
	up,
	down_left,
	down_right
}
var current_move_state = move_state.idle

func _ready():
	anim_player.play("idle")

#basic WASD movement
func _physics_process(delta):
	handle_input()
	handle_movement(delta)
	handle_collisions(delta)
	string.points = _get_points()
	#print("state:" , move_state.keys()[current_move_state])
	
func handle_collisions(delta:float):
	var col = move_and_collide(move_dir*move_speed*delta)
	if col: print(col.get_collider().name)
	
func handle_input():
	move_dir = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_up","move_down"))
	
func handle_movement(delta):
	set_facing()
	if near_zero_v(move_dir):
		current_move_state = move_state.idle
		if facing == 1:
			$PlayerSprite.flip_h = false
		if facing == -1:
			$PlayerSprite.flip_h = true
	else:
		if moving_sideways():
			if facing > 0: current_move_state = move_state.right
			else: current_move_state = move_state.left
		else: 
			if moving_upwards():
				current_move_state = move_state.up
			else: 
				# TODO: check again after set_facing() is fixed
				if facing < 0:
					current_move_state = move_state.down_right
				else:
					current_move_state = move_state.down_left
					
					
# TODO: facing should flip when move_dir.x crosses 0 on the frame
#		not just read the raw value
func set_facing():
	if move_dir.x < -epsilon: facing = -1
	elif move_dir.x > epsilon : facing = 1
	else: facing = 0

func moving_sideways():
	return abs(move_dir.x)>= abs(move_dir.y)

func moving_upwards():
	return move_dir.y < 0

func near_zero_v(vec: Vector2) -> bool:
	return vec.length() <epsilon
	
func near_zero_f(val : float) ->bool:
	return abs(val) < epsilon

func _get_points() -> Array:
	var points := []
	var start := self.global_position as Vector2
	var target = flail.global_position as Vector2
	var distance = (target - start) as Vector2
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x = start.x + (distance.x / ARC_POINTS) * i
		var y = start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	points.append(target)
	
	return points
	
func ease_out_cubic(number:float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)
