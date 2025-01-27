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
@export var health : int = 100
const max_health : int = 100
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

#projectile prefab
@onready var sinewave = preload("res://Enemy/boss2/sinewave.tscn")
@onready var eighth_note = preload("res://Enemy/boss2/eighth_note.tscn")
@onready var quarter_note = preload("res://Enemy/boss2/quarter_note.tscn")

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

func _on_state_enter(state):
	super(state)
	print(state)
	if state == boss_states.idle_human:
		anim_player.play("idle_human")
	if state == boss_states.idle:
		anim_player.play("idle")
	if state == boss_states.transformation:
		anim_player.play("transformation")
	
	
func _on_state_exit(state) -> void:
	super(state)
	if current_state == boss_states.death: boss_dead.emit()
	

func _on_state_tick(state, delta) -> void:
	super(state, delta)
	
	if (state == boss_states.idle) and (is_ready):
		#check if idle timer triggers
		print("tick")
		if idle_timer <= 0:
			print("here")
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

		
	

func pick_attack_pattern():
	print("here")
	var i = randf_range(0,1) 
	if i < 0.45:
		_set_state(boss_states.double_attack)

	elif i < 0.9 : 
		_set_state(boss_states.single_attack)

	else : _set_state(boss_states.idle)
	


func _on_animation_player_animation_finished(anim_name: StringName):
	print("done")
	print(anim_name)
	if (current_state == boss_states.phase2_single or 
			current_state == boss_states.single_attack or
			current_state == boss_states.double_attack or
			current_state == boss_states.aoe_attack or
			current_state == boss_states.phase2_aoe or 
			current_state == boss_states.phase2_double or
			current_state == boss_states.phase2_single or
			current_state == boss_states.transformation
			): 
		_set_state(boss_states.idle)

func on_take_damage(damage):
	if current_state == boss_states.death:
		return
	else:
		print("Orb Boss Took Damage: " , damage)
		take_damage.emit(damage)
		health -= damage
		if health <= 0: _set_state(boss_states.death)
	
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print("Body entered: ",body)
	print("state ",current_state)
	print("boolean ",body is Player and current_state == boss_states.idle_human)
	if body is Player and current_state == boss_states.idle_human:
		print("state ",current_state)
		_set_state(boss_states.transformation)
		print("state ",current_state)
		is_ready = true
		ready_to_fight.emit()

func create_projectile():
	await get_tree().create_timer(10).timeout
	var projectile = eighth_note.instantiate()
	projectile.position = position
	projectile.position.y += 25
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
	#TODO: impliment player death on touching boss
	if body is Player:
		body.take_damage()
