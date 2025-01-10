extends Area2D

#signal to know what level the player is at
signal go_to_level()

@onready var blockage: CollisionShape2D = $StaticBody2D/CollisionShape2D2
@onready var door: TileMapLayer = $StaticBody2D/TileMapLayer
@export var level:String

var is_open:bool = false

func _on_timer_timeout():
	print("timeout")
	is_open = true
	blockage.disabled = is_open
	door.clear()

func _on_body_entered(body: PhysicsBody2D):
	print(body.name)
	if body.name == "Player":
		print("going")
		emit_signal("go_to_level", load(level))
