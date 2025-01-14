class_name BossRoom2
extends Level

# NOT YET SET UP

@export var level_number : int = 2
#signal boss_ready
signal boss_health_gui_update(delta)

func start_level():
	print("starting level 2")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_announce_position(pos):
	pass # Replace with function body.
