class_name BossRoom2
extends Level

# NOT YET SET UP

@export var level_number : int = 2
#signal boss_ready
signal boss_health_gui_update(delta)
signal boss_death_gui_update
signal boss_start_fight_gui_update
signal level_complete

var mrs_melodie_prefab: PackedScene = preload("res://Enemy/boss2/mrs_melodie.tscn")
var mrs_meloide
var boss_alive = true

func start_level():
	print("starting level 2")

# Called when the node enters the scene tree for the first time.
func _ready():
	close_doors()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_announce_position(pos):
	pass # Replace with function body.


func _on_mrs_melodie_ready_to_fight() -> void:
	print("Mrs_Melodie Boss Ready!")
	$Mrs_Melodie/ActivateFightDetector.visible = false
	boss_start_fight_gui_update.emit()
	
func close_doors():
	$TerrainContainer/door_toggle.visible = true

func open_doors():
	$TerrainContainer/door_toggle.visible = false
	


func _on_mrs_melodie_boss_dead() -> void:
	print("boss dead")


func _on_mrs_melodie_create_mimic(pos: Variant) -> void:
	print(name, " apply damage")
	

func _on_mrs_melodie_take_damage(damage: Variant) -> void:
	print(name, " apply damage")
	boss_health_gui_update.emit(-damage)
