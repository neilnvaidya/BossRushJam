extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	animated_sprite_2d.play("Idle")

func hide_screen():
	animated_sprite_2d.stop()
	self.hide()
