extends Control

var portrait_paths = {
	base = preload("res://Assets/Art/GUI/Expressions/portrait_expression1.png"),
	talk1 =preload("res://Assets/Art/GUI/Expressions/portrait_expression2.png"),
	blink =preload("res://Assets/Art/GUI/Expressions/portrait_expression3.png"),
	talk2 = preload("res://Assets/Art/GUI/Expressions/portrait_expression4.png"),
	surprise = preload("res://Assets/Art/GUI/Expressions/portrait_expression5.png"),
	squint = preload("res://Assets/Art/GUI/Expressions/portrait_expression6.png"),
	side_eye = preload("res://Assets/Art/GUI/Expressions/portrait_expression7.png"),
	happy = preload("res://Assets/Art/GUI/Expressions/portrait_expression8.png"),
	tired = preload("res://Assets/Art/GUI/Expressions/portrait_expression9.png"),
	scared =preload( "res://Assets/Art/GUI/Expressions/portrait_expression10.png"),
	hurt1 = preload("res://Assets/Art/GUI/Expressions/portrait_expression11.png"),
	hurt2 =  preload("res://Assets/Art/GUI/Expressions/portrait_expression12.png")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# TODO: # Player health should update the portrait, can also use some randomness.
		# note the names in paths above
