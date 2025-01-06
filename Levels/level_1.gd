extends Node2D

# ONLY CAMERON SHOULD EDIT THIS FROM NOW ON

@onready var player : CharacterBody2D = $Player
@onready var camera : Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position
