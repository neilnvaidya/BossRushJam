class_name Tutorial
extends Level

@export var level_number : int = 0
signal tutorial_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	tutorial_complete.emit()

# since tutorial is first, start level is just a go point.
func start_level():
	print("Starting Tutorial")
