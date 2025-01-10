class_name Run
extends Node2D

#var player_stats: PlayerStats
@onready var player = $Player
#@onready var yoyo_handler = $YoyoHandler
@onready var camera : Camera2D = $Camera2D

func _ready():
	#player_stats = PlayerStats.new()
	#player_stats.starting_yoyo = TEST_YOYO #TODO change this
	#yoyo_handler.player_stats=player_stats
	#yoyo_handler.active_yoyos.append(player_stats.starting_yoyo)
	#yoyo_handler.handler_setup()
	camera.position = player.position
	
func _physics_process(delta):
	camera.position = player.position
