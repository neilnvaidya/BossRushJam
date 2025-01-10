extends ColorRect

signal starting

func _input(event):
	if event.is_action_pressed("ui_accept"):
		start_game()

func start_game():
	emit_signal("starting")
	print("starting" + str($Button))
	queue_free()
