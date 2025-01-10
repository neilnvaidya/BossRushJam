class_name Yoyo
extends RigidBody2D

@export var yoyo_stats: YoyoStats : set = _set_yoyo
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
var damage_multiplier : int
var has_hit = false


func _ready(): 
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_speed = self.linear_velocity.length()
	current_speed = int(current_speed)
	damage_multiplier = current_speed / 100
	if has_hit == true:
		await get_tree().create_timer(300).timeout
		has_hit = false
		
func _set_yoyo(value: YoyoStats) ->void:
	if not is_node_ready():
		await ready
	yoyo_stats = value
	sprite_2d.texture = value.icon

func _on_body_entered(body):
	if not has_hit:
		if body.name == "Boss":
			var calculated_damage = damage_multiplier * yoyo_stats.base_damage
			has_hit = true
			print("hit boss - Damage: ", calculated_damage)
			
