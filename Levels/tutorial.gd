class_name Tutorial
extends Level
@onready var door: TileMapLayer = $TerrainContainer/Door

@export var level_number : int = 0
signal tutorial_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	start_level()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	tutorial_complete.emit()
	door.visible = false
	door.collision_enabled = false
	

# since tutorial is first, start level is just a go point.
func start_level():
	print("Starting Tutorial")
