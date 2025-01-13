extends CharacterBody2D

var travel_direction : Vector2 = Vector2.ZERO
var is_launched : bool = false
const speed : float = 100

func _ready():
	pass
	


func _physics_process(delta):
	if is_launched:
		var collision = move_and_collide(travel_direction*speed*delta)
		if collision:
			on_collision(collision)
	

func on_collision(col):
	print("Projectile Collision: ", col.get_collider().name)
	queue_free()

func launch(dir):
	#print("PROJECTILE dLAUNCH")
	is_launched = true
	travel_direction = dir
	
