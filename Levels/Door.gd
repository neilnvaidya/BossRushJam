#TODO: I belive this is defunct now, if so remove it and the scene - Neil

extends Area2D

enum Compass {North, South, East, West}

@export var transition_direction:Compass

func _on_body_entered(body):
	#Messenger.TRIGGER_TRANSITION.emit(transition_direction)
	pass
	
static func get_direction_vector(compass_direction) -> Vector2:
	match(compass_direction):
		Compass.North:
			return Vector2(0, -2)
		Compass.South:
			return Vector2(0, 2)
		Compass.East:
			return Vector2(2, 0)
		Compass.West:
			return Vector2(-2, 0)
	return Vector2()
