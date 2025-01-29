extends Area2D
class_name Projectiles

var travel_direction : Vector2 = Vector2.ZERO
var is_launched : bool = false
const speed : float = 100

func _ready():
	pass
	

func launch(dir):
	#print("PROJECTILE dLAUNCH")
	is_launched = true
	travel_direction = dir


func _on_body_entered(body):
	if body is Player:
		body.take_damage()
	if body is not Boss:
		queue_free()
