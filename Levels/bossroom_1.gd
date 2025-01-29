class_name BossRoom1
# Bossroom 1 has:
# Control over doors leading in and out of it
# Specific elements for Orb Boss
# Connections to the GUI via signals

extends Level

@export var level_number : int = 1
#signal boss_ready
signal boss_health_gui_update(delta)
signal boss_death_gui_update
signal boss_start_fight_gui_update
signal orb_boss
signal level_complete

var mimic_prefab : PackedScene = preload("res://Enemy/Boss/OrbBoss/orb_boss.tscn")
var mimic
var boss_alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	close_doors()
	$TerrainContainer/door_closed.visible = false
	$TerrainContainer/boss_door.collision_enabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$TerrainContainer/door_closed.visible = boss_alive

# start level opens doors the player may enter, does not start fight, 
# boss will decide fight start conditions
func start_level():
	close_doors()
	open_doors()
	
## THis is not connected to anything, see TODO in door
#func _on_door_on_player_enter(player, direction):
	#print("LEVEL 1 - door player enter: ", player.name, direction)


func close_doors():
	$TerrainContainer/boss_door.visible = true
	$TerrainContainer/boss_door.collision_enabled = true

func open_doors():
	$TerrainContainer/boss_door.visible = false
	$TerrainContainer/boss_door.collision_enabled = false
	
func _on_orb_boss_ready_to_fight():
	print("Orb Boss Ready!")
	boss_start_fight_gui_update.emit()
	close_doors()
	$OrbBoss/ActivateFightDetector.visible = false

func _on_orb_boss_take_damage(damage):
	print(name, " apply damage")
	print(damage)
	boss_health_gui_update.emit(-damage)


func _on_player_announce_position(pos):
	if boss_alive:
		var boss = get_node("OrbBoss") as OrbBoss
	

func _on_orb_boss_create_mimic(pos):
	print("creating mimic")
	mimic = mimic_prefab.instantiate() as OrbBoss
	print(mimic)
	mimic.position= pos
	mimic.is_mimic = true
	mimic.name = "Mimic"
	mimic.move_targets = $MoveTargetContainer.get_children()
	$MimicContainer.add_child(mimic)


func _on_orb_boss_boss_dead():
	boss_alive = false
	open_doors()
	level_complete.emit()
	boss_death_gui_update.emit()
	
