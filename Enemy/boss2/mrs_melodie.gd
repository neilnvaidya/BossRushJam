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
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

#projectile prefab
@onready var projectile = [preload("res://Enemy/boss2/eighth_note.tscn"),preload("res://Enemy/boss2/eighth_note.tscn"),
preload("res://Enemy/boss2/quarter_note.tscn"),preload("res://Enemy/boss2/sinewave.tscn")]


enum boss_states {
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
	}
	
func _init():
	super()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	anim_player = $AnimationPlayer
	collider = $CollisionShape2D
	
func _on_state_tick(state, delta) -> void:
	super(state, delta)
	
	#set the boss to face player
	set_facing_player()
	
	if state == boss_states.idle:
		#check if idle timer triggers
		if idle_timer <= 0:
			pick_attack_pattern()
		else:
			idle_timer -= delta
		
		#apply facing and anim
		if facing_changed:
			var anim_position = anim_player.current_animation_position
			if facing == 1: 
				anim_player.play("idle2_right")
			else: anim_player.play("idle2_left")
			anim_player.seek(anim_position)
	
	#
	if state == boss_states.idle:

		# if near the target go back to idle
		var relative_pos = move_position - position
		if relative_pos.length() < 1:
			_set_state(boss_states.idle)
		else:
			# else move towards the target
			var dir = relative_pos.normalized()
			var speed = move_speed
			move_and_collide(dir * speed*delta)
			if facing_changed:
				# turn around if facing changed
				var anim_position = anim_player.current_animation_position
				if facing == 1: 
					anim_player.play("idle2_right")
				elif facing ==-1 : anim_player.play("idle2_left")
				else:
					anim_player.play("idle_up")
				anim_player.seek(anim_position)
				
				
func pick_attack_pattern():
	var i = randf_range(0,1) 
	if i < 0.45:
		pass
	elif i < 0.9 : _set_state(boss_states.idle)
	else : _set_state(boss_states.idle)
	
func set_facing_player() -> void:
	var new_facing : int
	player_position = get_tree().get_first_node_in_group("Player").global_position as Vector2
	if player_position.y > abs(player_position.x) and (player_position.y - position.y) > 0:
		new_facing = 0
	else:	
		if player_position.x < position.x:
			new_facing = -1
		else : 
			new_facing  = 1
		
	if new_facing != facing:
		facing_changed = true
		print(facing)
		facing = new_facing
	else: facing_changed = false
