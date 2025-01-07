extends Node2D

# SgtChilli Test Level

@onready var player : CharacterBody2D
@onready var camera : Camera2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_door_on_player_enter(player, direction):
	print("LEVEL 1 - door player enter: ", player.name, direction)
