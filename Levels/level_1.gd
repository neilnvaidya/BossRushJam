extends Node2D

signal go_to_level(level)
@export var level:String

func _on_door_go_to_level(lvl: Variant) -> void:
	print("void")
	emit_signal("go_to_level", load(level))
