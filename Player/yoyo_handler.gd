class_name YoYoHandler
#extends Node
extends Node2D

#const YOYOSPRITE = preload("res://Yoyo/yoyo_prefab.tscn")
#@export var player_stats : PlayerStats

var active_yoyos: Array[YoyoStats]
var yoyo_speed: int
@onready var yoyos = $Yoyos
@onready var strings = $Strings
@onready var pinjoints = $Pinjoints

const ARC_POINTS := 10
#const TEST_YOYO = preload("res://Resources/YoYo/test_yoyo.tres")
const STRING = preload("res://Yoyo/String.tscn")
const TEST_YOYO = preload("res://Yoyo/TestYoyo/test_yoyo.tres")
const YOYO_PREFAB = preload("res://Yoyo/TestYoyo/test_yoyo.tscn")



func _ready():
	print(get_parent())
	
func handler_setup():
	set_initial_yoyos()
	create_children()
	assignjoints()

func _physics_process(_delta):
	for i in yoyos.get_children().size():
		var stringcanvas = strings.get_child(i)
		var stringline = stringcanvas.get_child(0)
		stringline.points = _get_points(yoyos.get_children()[i])
		

func set_initial_yoyos():
	active_yoyos.append(TEST_YOYO)
	
func create_children():
	for yoyo in active_yoyos:
		var new_yoyo_child := YOYO_PREFAB.instantiate() as RigidBody2D
		new_yoyo_child.yoyo_stats = yoyo
		yoyos.add_child(new_yoyo_child)


func assignjoints():
	for yoyo in yoyos.get_children():
		yoyo.position = position + Vector2(0,50)
		var joint = PinJoint2D.new()
		joint.softness = 16
		joint.node_a = get_parent().get_path()
		print(joint.node_a)
		joint.node_b = yoyo.get_path()
		print(joint.node_b)
		pinjoints.add_child(joint)
	for i in active_yoyos.size():
		var new_string_child := STRING.instantiate() as CanvasLayer
		strings.add_child(new_string_child)

func _get_points(node) -> Array:
	var points := []
	var start := get_parent().position as Vector2
	var target = node.position  + get_parent().position as Vector2

	var distance = (target - start) as Vector2
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x = start.x + (distance.x / ARC_POINTS) * i
		var y = start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	points.append(target)
	
	#print(points[0], points[-1])
	
	return points

func ease_out_cubic(number:float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)
