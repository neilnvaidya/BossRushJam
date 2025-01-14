extends Control

@onready var boss_health_bar: ProgressBar = $BossStatsContainer/BossHealthBar



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _on_boss_health_gui_update(delta):
	print("GUI: update boss health: ", delta," ", boss_health_bar.value)
	var new_health = boss_health_bar.value +delta
	boss_health_bar._set_health(new_health)

# TODO: hide boss health when boss dies, may be better to make a 
# 		generic named funciotn that is called from all boss rooms 
# 		emiting a signal to GUI

func _on_bossroom_1_boss_death_gui_update():
	pass # Replace with function body.

# TODO
func hide_boss_healthbar():
	pass
# TODO
func show_boss_healthbar():
	pass

# TODO: 
# is called when the boss decides to start fight,
# should show boss healthbar and enable the functionality.
# Before this is called assume boss cannot take damage
func _on_bossroom_1_boss_start_fight_gui_update():
	pass # Replace with function body.
