extends Node2D

@onready var left_button = $a_button
var left_pressed
@onready  var right_button = $d_button
var right_pressed
@onready var up_button = $w_button
var up_pressed
@onready var down_button = $s_button
var down_pressed
@onready var interact_button = $e_button
var interact_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	left_button.set_pressed(left_pressed)
	right_button.set_pressed(right_pressed)
	up_button.set_pressed(up_pressed)
	down_button.set_pressed(down_pressed)
	interact_button.set_pressed(interact_pressed)

	
func _input(event):
	if event.is_action("move_left"):
		left_pressed = event.is_pressed()
	if event. is_action("move_right"):
		right_pressed = event.is_pressed()
	if event. is_action("move_up"):
		up_pressed = event.is_pressed()	
	if event. is_action("move_down"):
		down_pressed= event.is_pressed()
	if event. is_action("interact"):
		interact_pressed = event.is_pressed()
	
