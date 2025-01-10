extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: Player = $Player

@export var start_scene:String
@onready var mark: Marker2D = $Mark


#need to clear the node after lvl is finish
var current_level:Node2D
var old_level:Node2D

#instantiate the scenes 
func _ready():
	current_level = load(start_scene).instantiate()
	$Levels.add_child(current_level)
	current_level.connect("go_to_level",Callable(self, "_on_go_to_level"))
	camera.position = player.position
	spawn_point()
	
func _physics_process(delta):
	camera.position = player.position
	print(mark)
	
func _on_go_to_level(scene:PackedScene):
	print("game world")
	var new_level=scene.instantiate()
	$Levels.add_child(new_level)
	spawn_point()
	old_level=current_level
	new_level.connect("go_to_level",Callable(self,"_on_go_to_level"))
	current_level=new_level
	get_tree().paused=false
	old_level.queue_free()

func spawn_point():
	print(mark)
	if mark:
		player.position = mark.position
