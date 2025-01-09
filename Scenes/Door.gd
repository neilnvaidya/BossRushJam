extends Area2D

#signal to know what lvl the player is at
signal player_enter_door(body)

@onready var blockage: CollisionShape2D = $StaticBody2D/CollisionShape2D2
@onready var door: TileMapLayer = $StaticBody2D/TileMapLayer

var is_open:bool = false

func _on_timer_timeout():
	print("timeout")
	is_open = true
	blockage.disabled = is_open
	door.clear()


func _on_body_entered(body: Node2D):
	print(body.name+" entered")
	if body.name == "Player":
		emit_signal("player_enter_door",body)
