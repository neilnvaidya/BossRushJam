class_name Run
extends Node2D

var current_level_index : int = game_level.tutorial

#Music Variables
var sleeper

enum game_level {
	tutorial,
	level_1,
	level_2
}

var levels = []
var current_level : Node2D

#var player_stats: PlayerStats
@onready var player = $Player
#@onready var yoyo_handler = $YoyoHandler
@onready var camera : Camera2D = $Camera2D
@onready var gui: Control = $CanvasLayer/GUI

func _ready():
	for c in $LevelsContainer.get_children():
		if c is Level:
			levels.append(c)
		
	camera.position = player.position
	var sleeper = AudioPlayer.play_area("res://Assets/Audio/music/Sleeper.ogg")

func _physics_process(_delta):
	camera.position = player.position

func start_next_level():
	print("starting level:" , current_level_index + 1)
	if current_level_index < game_level.size()-1:
		current_level_index = current_level_index + 1
		levels[current_level_index].start_level()
	
func _on_tutorial_tutorial_complete():
	start_next_level()


func _on_bossroom_1_level_complete():
	start_next_level()
