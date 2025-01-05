class_name YoYoHandler
extends Node

var active_yoyos: Array[YoYo] = []


func get_yoyos() -> Array[YoYo]:
	for child: YoYo in (self.get_children() as Array[YoYo]):
		active_yoyos.append(child)
	return active_yoyos
