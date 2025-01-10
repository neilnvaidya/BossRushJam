extends Node2D

@export var level_number : int = 1
signal boss_ready
signal boss_health_gui_update(delta)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_door_on_player_enter(player, direction):
	print("LEVEL 1 - door player enter: ", player.name, direction)


func _on_orb_boss_ready_to_fight():
	print("Orb Boss Ready!")


func _on_orb_boss_take_damage(damage):
	boss_health_gui_update.emit(-damage)
