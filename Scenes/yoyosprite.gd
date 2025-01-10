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
<<<<<<< Updated upstream
=======

func _on_body_entered(body):
	if not has_hit:
		if body.name == "Boss":
			var calculated_damage = damage_multiplier * yoyo.base_damage
			Messenger.HIT.emit(body, calculated_damage)
			has_hit = true
>>>>>>> Stashed changes
