## YOYO is RigidBody, but the collision detection uses an Area2D
## This version is good for pass through damage.

extends RigidBody2D
@export var yoyo: YoYo : set = _set_yoyo
@onready var sprite_2d = $Sprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_yoyo(value: YoYo) ->void:
	if not is_node_ready():
		await ready
	yoyo = value
	sprite_2d.texture = value.icon




# Detects overlap of the area
func _on_area_2d_body_entered(body):
	print("YoYo(AREA2D _ body enter) collision: ", body.name)
