extends Area2D

# This is a simple implementation of door, We really should have a Node2D (Door) as the parent,
# with a static body which blocks the player moving through and an Area2D (TransitionDetector) 
# to detect that the player is near the door so we can transition the levels. 
# When the player reaches the door area, then if the door is open, 
# disable the static body to allow passage

# There are other ways to do this, but at minimum we will need 
# to consider how the signals are sent around


# Direct of the door
enum Compass {North, South, East, West}

@export var transition_direction:Compass # Set in inspector

# Will pass signal up the tree
signal on_player_enter(player, direction)

#Tracking variables
var can_open : bool = false
var is_open: bool = false

#Make sure starts closed
func _ready():
	on_close()

#When door opens, set to transparent
func on_open():
	$Sprite2D.modulate= Color(0,0,0,0)
	is_open = true

# When door closes set to black
func on_close():
	$Sprite2D.modulate = Color.BLACK
	is_open = false
	
	#when a body enters Area2D,  if it is a player, emit signal (is connected to level 1)
func _on_body_entered(body):
	print("DOOR -  body entered :", body.name)
	if body is Player and is_open:
		emit_signal("on_player_enter", body, transition_direction)

# A Timer to help with testing
func _on_timer_timeout():
	print("timer ends")
	on_open()
