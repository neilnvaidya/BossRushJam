class_name Yoyo
extends RigidBody2D

@export var yoyo_stats: YoyoStats : set = _set_yoyo
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
var damage_multiplier : int
var has_hit = false
var current_speed 

#YoYo Loop Var
@export var YOYOLOOP_BUS = AudioServer.get_bus_index("YoYoLoop")
@export var pitch:float:
	get:
		return AudioServer.get_bus_effect(3,1).pitch_scale
	set(pitch):
		AudioServer.get_bus_effect(3,1).pitch_scale = pitch

func _ready(): 
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	current_speed = self.linear_velocity.length()
	#current_speed = int(current_speed)
	damage_multiplier = current_speed / 100
	##Yoyo Audio System
	if current_speed < 150:
		AudioServer.set_bus_volume_db(YOYOLOOP_BUS, -30)
	elif 400 < current_speed and 1000 > current_speed:
		AudioServer.set_bus_volume_db(YOYOLOOP_BUS, 0)
	else:
		AudioServer.set_bus_mute(YOYOLOOP_BUS, 0)
		AudioServer.set_bus_volume_db(YOYOLOOP_BUS, (((current_speed) / 10)-40))
	
	if 400 < current_speed and 1000 > current_speed:
		pitch = 1
	elif current_speed < 200:
		pitch = 0.5
	else:
		pitch = current_speed / 400
	#print(current_speed)
	
	if has_hit == true:
		await get_tree().create_timer(300).timeout
		has_hit = false
		
func _set_yoyo(value: YoyoStats) ->void:
	if not is_node_ready():
		await ready
	yoyo_stats = value
	sprite_2d.texture = value.icon
	AudioPlayer.play_yoyoloop("res://Assets/Audio/player/yoyo_yoyoloop1.wav")

func _on_body_entered(body):
	if not has_hit:
		if body.name == "Boss":
			var calculated_damage = damage_multiplier * yoyo_stats.base_damage
			has_hit = true
			print("hit boss - Damage: ", calculated_damage)
			
