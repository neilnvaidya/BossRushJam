extends Node2D

@export var level_number : int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_door_on_player_enter(player, direction):
	print("LEVEL 1 - door player enter: ", player.name, direction)
