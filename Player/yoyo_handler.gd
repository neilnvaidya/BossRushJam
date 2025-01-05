class_name YoYoHandler
extends Node
const YOYOSPRITE = preload("res://Scenes/yoyosprite.tscn")
@export var player_stats : PlayerStats
var active_yoyos: Array[YoYo]

func set_yoyos():
	active_yoyos = player_stats.yoyo_collection

func create_children():
	for yoyo in active_yoyos:
		var new_yoyo_child := YOYOSPRITE.instantiate() as RigidBody2D
		new_yoyo_child.yoyo = yoyo
		self.add_child(new_yoyo_child)
