class_name Run
extends Node2D

const TEST_YOYO = preload("res://yoyos/test_yoyo.tres")
var player_stats: PlayerStats
@onready var player = $Player

func _ready():
	player_stats = PlayerStats.new()
	player_stats.starting_yoyo = TEST_YOYO #TODO change this
	player.yoyo_handler.active_yoyos.append(player_stats.starting_yoyo)
