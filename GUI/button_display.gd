extends Node2D

@export var texture : Texture
@export var frame : int
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = texture
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_pressed(is_pressed):
	if is_pressed: $Sprite2D.frame = 1
	else: $Sprite2D.frame = 0
