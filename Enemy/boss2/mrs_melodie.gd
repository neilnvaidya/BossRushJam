class_name Mrs_Meldoie
extends Boss

#signals
signal take_damage(damage)
signal ready_to_fight
signal create_mimic(pos)
signal boss_dead

#local references
var anim_player :AnimationPlayer
var sprite : Sprite2D
var collider : CollisionShape2D 

#tracker
var is_mimic: bool = false
var is_ready : bool = false
var facing_changed: bool = false
@export var facing: int = 1
@export var current_phase : int = 1

# external references and tranckers
@export var move_target_container : Node2D
var move_targets : Array[Node]
var move_position :Vector2 = Vector2.ZERO
@export var player_position : Vector2 = Vector2.ZERO

#balance vars
@export var min_idle_timer:  float = 5.0
@export var max_idle_timer: float = 0.5
var idle_timer : float = 0.0

@export var move_speed : float = 40
@export var bite_range : Vector2 = Vector2(50,50)
@export var health : int = 200
const max_health : int = 200
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

#projectile prefab
@onready var sinewave = preload("res://Enemy/boss2/sinewave.tscn")
@onready var eighth_note = preload("res://Enemy/boss2/eighth_note.tscn")
@onready var quarter_note = preload("res://Enemy/boss2/quarter_note.tscn")
@onready var half_note = preload("res://Enemy/boss2/half_note.tscn")

#Audio Var Setup
@export var AREA_BUS = AudioServer.get_bus_index("Area")
var piano_music 
var area_volume:AudioEffectAmplify = AudioServer.get_bus_effect(4,0)
@export var piano_hurt: AudioStream
@export var piano_shoot: AudioStream

enum boss_states {
	idle_human,
	idle,
	aoe_attack,
	death,
	double_attack,
	hurt,
	immune,
	return_idle,
	single_attack,
	transformation,
	phase2_aoe,
	phase2_double,
	phase2_idle,
	phase2_hurt,
	phase2_return_idle,
	phase2_single,
	destroy_object,
	}

func _init():
	super()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	anim_player = $AnimationPlayer
	collider = $CollisionShape2D
	print(current_state)
	_set_state(boss_states.idle)

#start the fight with boss 2
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	ready_to_fight.emit()
	if body is Player and current_state == boss_states.idle and !is_ready:
		print("state ",current_state)
		_set_state(boss_states.transformation)
		print("state ",current_state)
		is_ready = true
		

func _on_state_exit(state) -> void:
	super(state)
	if current_state == boss_states.death: boss_dead.emit()
	

func _on_state_tick(state, delta) -> void:
	super(state, delta)
	
	if (state == boss_states.idle) and (is_ready):
		#check if idle timer triggers
		print("idle",idle_timer)
		if idle_timer <= 0:
			idle_timer = 5
			pick_attack_pattern()
		else:
			idle_timer -= delta
	
	#TODO:
	#generata attack
	if state == boss_states.double_attack:
		anim_player.play("double_attack")
		create_projectile()
	
	elif state == boss_states.single_attack:
		anim_player.play("single_attack")
		create_projectile()
	
	#health check
	if health <0:
		_set_state(boss_states.death)
	

func pick_attack_pattern():
	print("here")
	var i = randf_range(0,1) 
	if i < 0.33:
		_set_state(boss_states.double_attack)
		print("double")
	elif i > 0.33 or i < 0.66 : 
		_set_state(boss_states.single_attack)
		print("single")
	else :
		_set_state(boss_states.immune)
		print("immune")


func _on_animation_player_animation_finished(anim_name: StringName):
	print("done")
	if current_state == boss_states.death:
		_set_state(boss_states.destroy_object)
	
	if (current_state == boss_states.aoe_attack or
		current_state == boss_states.double_attack or
		current_state == boss_states.single_attack or
		current_state == boss_states.return_idle or
		current_state == boss_states.transformation or
		current_state == boss_states.phase2_aoe or
		current_state == boss_states.phase2_double or
		current_state == boss_states.phase2_single or
		current_state == boss_states.phase2_return_idle or
		current_state == boss_states.hurt or
		current_state == boss_states.return_idle):
			_set_state(boss_states.idle)

	if (current_state == boss_states.immune):
			_set_state(boss_states.return_idle)
			
func on_take_damage(damage):
	if current_state == boss_states.death:
		anim_player.play("death")
		return
	else:
		print("Mrs Meldoies Took Damage: " , damage)
		take_damage.emit(damage)
		AudioPlayer.play_sound("res://Assets/Audio/enemy/yoyo_enemyhit1.wav")
		AudioPlayer.play_stream(piano_hurt)
		health -= damage
		boss_states.hurt
		anim_player.play("hurt")
		if health <= 0: 
			print(health)
			_set_state(boss_states.death)
	


func create_projectile():
	var projectile #Shoot SFX commented out until projectile glitches fixed
	await get_tree().create_timer(10).timeout
	var i = randf_range(0,1) 
	if i < 0.33:
		projectile = eighth_note.instantiate()
		print("eighth_note")
		#AudioPlayer.play_stream(piano_shoot, 0.001)
	elif i>0.33 and i<.66:
		projectile = half_note.instantiate()
		print("half")
		#AudioPlayer.play_stream(piano_shoot, 0.001)
	else:
		projectile = quarter_note.instantiate()
		print("quarter_note")
		#AudioPlayer.play_stream(piano_shoot, 0.001)
		
	projectile.position = position
	projectile.position.y += 25
	projectile.position.x += 25
	
	if facing != 0:
		projectile.position.x += 25*facing
		
	get_parent().add_child(projectile)
	var dir = (player_position - position).normalized()
	
	projectile.launch(dir)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body is Yoyo:
		var damage = body.yoyo_stats.base_damage*body.damage_multiplier
		on_take_damage(damage)

	if body is Player:
		body.take_damage()
		
func _on_state_enter(state):
	super(state)
	print(state)
	if state == boss_states.idle:
		anim_player.play("idle")
		
	if state == boss_states.transformation:
		anim_player.play("transformation")
		var tween := create_tween()
		tween.tween_property(area_volume, "volume_db", -80, 4)
		AudioPlayer.play_sound("res://Assets/Audio/enemy/piano boss/yoyo_pianotransform1.wav")
		var piano_music = AudioPlayer.play_music("res://Assets/Audio/music/Piano Boss.ogg", 0.7)
		print("end of transformation",state)
