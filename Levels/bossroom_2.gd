class_name BossRoom2
extends Level

# NOT YET SET UP

@export var level_number : int = 2
#signal boss_ready
signal boss_health_gui_update(delta)
signal boss_death_gui_update
signal boss_start_fight_gui_update
signal level_complete

var boss_alive = true

func start_level():
	print("starting level 2")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_Melodie_boss_ready_to_fight():
	print("Melodie Boss Ready!")
	$OrbBoss/ActivateFightDetector.visible = false

func _on_player_announce_position(pos):
	if boss_alive:
		var boss = get_node("Mrs_Melodie") as OrbBoss
