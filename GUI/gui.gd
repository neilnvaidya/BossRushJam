extends Control

@onready var boss_health_bar: ProgressBar = $BossStatsContainer/BossHealthBar



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _on_level_1_boss_health_gui_update(delta):
	print("GUI: update boss health: ", delta," ", boss_health_bar.value)
	var new_health = boss_health_bar.value +delta
	boss_health_bar._set_health(new_health)
