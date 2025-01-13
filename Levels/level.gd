extends Node2D

@export var level_number : int = 1
#signal boss_ready
signal boss_health_gui_update(delta)
var mimic_prefab : PackedScene = preload("res://Enemy/Boss/OrbBoss/orb_boss.tscn")
var mimic
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_door_on_player_enter(player, direction):
	print("LEVEL 1 - door player enter: ", player.name, direction)


func _on_orb_boss_ready_to_fight():
	print("Orb Boss Ready!")


func _on_orb_boss_take_damage(damage):
	print(name, " apply damage")
	boss_health_gui_update.emit(-damage)


func _on_player_announce_position(pos):
	var boss = get_node("OrbBoss") as OrbBoss
	boss.player_position = pos + position
	


func _on_orb_boss_create_mimic(pos):
	print("creating mimic")
	mimic = mimic_prefab.instantiate() as OrbBoss
	print(mimic)
	mimic.position= pos
	mimic.is_mimic = true
	mimic.name = "Mimic"
	$MimicContainer.add_child(mimic)
	
