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
@onready var projectile_prefab = preload("res://Enemy/boss2/eighth_note.tscn"),preload("res://Enemy/boss2/half_note.tscn")
