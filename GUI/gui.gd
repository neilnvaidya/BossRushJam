extends Control

@onready var boss_health_bar: ProgressBar = $BossStatsContainer/BossHealthBar
@onready var label: Label = $BossStatsContainer/Control/Label
@onready var boss_stats_container: VBoxContainer = $BossStatsContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_boss_healthbar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_orb_boss():
	pass
	
func _on_boss_health_gui_update(delta):
	print("GUI: update boss health: ", delta," ", boss_health_bar.value)
	var new_health = boss_health_bar.value +delta
	boss_health_bar._set_health(new_health)
	

# TODO: hide boss health when boss dies, may be better to make a 
# 		generic named funciotn that is called from all boss rooms 
# 		emiting a signal to GUI

func _on_bossroom_1_boss_death_gui_update():
	print("boss 1 dead")# Replace with function body.
	hide_boss_healthbar()

# TODO
func hide_boss_healthbar():
	boss_stats_container.hide()
# TODO
func show_boss_healthbar():
	boss_stats_container.show()

# TODO: 
# is called when the boss decides to start fight,
# should show boss healthbar and enable the functionality.
# Before this is called assume boss cannot take damage

func _on_bossroom_1_boss_start_fight_gui_update() -> void:
	label.text = "Orb boss"
	show_boss_healthbar()


func _on_bossrom_2_boss_start_fight_gui_update() -> void:
	label.text = "Mrs. Medodie"
	show_boss_healthbar()

	
func _on_bossrom_2_level_complete() -> void:
	pass # Replace with function body.

#TODO: test
func _on_bossrom_2_boss_health_gui_update(delta: Variant) -> void:
	boss_health_bar.resetBar(200)
