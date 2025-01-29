extends Area2D

var travel_direction : Vector2 = Vector2.ZERO
var is_launched : bool = false
const speed : float = 100
@onready var animation_player = $Sprite2D/AnimationPlayer

func _ready():
	pass
	
func _physics_process(delta):
	if is_launched:
		translate(travel_direction * speed * delta)

func launch(dir):
	#print("PROJECTILE dLAUNCH")
	is_launched = true
	travel_direction = dir
	animation_player.play("static")

func _on_body_entered(body):
	if body is Player:
		body.take_damage()
	if body is not Boss:
		queue_free()
