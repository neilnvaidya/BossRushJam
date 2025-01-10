class_name Run
extends Node2D
const TEST_YOYO = preload("res://yoyos/test_yoyo.tres")
var player_stats: PlayerStats
@onready var player = $Player
@onready var yoyo_handler = $YoyoHandler

func _ready():
	player_stats = PlayerStats.new()
	player_stats.starting_yoyo = TEST_YOYO #TODO change this
	yoyo_handler.player_stats=player_stats
	yoyo_handler.active_yoyos.append(player_stats.starting_yoyo)
	yoyo_handler.handler_setup()
