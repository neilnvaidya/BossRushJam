class_name PlayerStats
extends Resource

signal stats_changed

@export var starting_yoyo : YoYo

var yoyo_collection : Array[YoYo] = []
var health := 3

#func _ready():
	#yoyo_collection.append(starting_yoyo)
