class_name Run
extends Node2D

#var player_stats: PlayerStats
@onready var player = $Player
#@onready var yoyo_handler = $YoyoHandler
@onready var camera : Camera2D = $Camera2D
@onready var gui: Control = $CanvasLayer/GUI

func _ready():
	camera.position = player.position

func _physics_process(_delta):
	camera.position = player.position
