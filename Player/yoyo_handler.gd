class_name YoYoHandler
extends Node
const YOYOSPRITE = preload("res://Scenes/yoyosprite.tscn")
@export var player_stats : PlayerStats
var active_yoyos: Array[YoYo]
@onready var yoyos = $Yoyos
@onready var strings = $Strings
@onready var pinjoints = $Pinjoints
const ARC_POINTS := 10
const TEST_YOYO = preload("res://yoyos/test_yoyo.tres")
const STRING = preload("res://Scenes/String.tscn")

func _physics_process(delta):
	# TODO: Not clear what you're doing here, please make functions for readability
	#Dan -> this assigns the lines for each yoyo and moves them with the yoyo
	for i in yoyos.get_children().size():
		var stringcanvas = strings.get_child(i)
		var stringline = stringcanvas.get_child(0)
		stringline.points = _get_points(yoyos.get_children()[i])
func set_yoyos():
	player_stats.yoyo_collection.append(player_stats.starting_yoyo)
	active_yoyos = player_stats.yoyo_collection

func create_children():
	for yoyo in active_yoyos:
		var new_yoyo_child := YOYOSPRITE.instantiate() as RigidBody2D
		new_yoyo_child.yoyo = yoyo
		yoyos.add_child(new_yoyo_child)

func _ready():
	set_yoyos()
	#remove
	create_children()
	
	for yoyo in yoyos.get_children():
		yoyo.position = get_parent().global_position + Vector2(0,50)
		var joint = PinJoint2D.new()
		joint.softness = 16
		joint.node_a = get_parent().get_path()
		joint.node_b = yoyo.get_path()
		pinjoints.add_child(joint)
	for i in active_yoyos.size():
		var new_string_child := STRING.instantiate() as CanvasLayer
		strings.add_child(new_string_child)

func _get_points(node) -> Array:
	var points := []
	var start := get_parent().global_position as Vector2
	var target = node.global_position as Vector2

	var distance = (target - start) as Vector2
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x = start.x + (distance.x / ARC_POINTS) * i
		var y = start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	points.append(target)
	
	return points

func ease_out_cubic(number:float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)
