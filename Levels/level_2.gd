extends Node2D
@onready var player : CharacterBody2D = $Player
@onready var camera : Camera2D = $Camera2D
@onready var mark: Marker2D = $Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = mark.position
	camera.position = player.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position


func _on_door_player_enter_door(body: Variant) -> void:
	print("going to lvl 1")
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")
