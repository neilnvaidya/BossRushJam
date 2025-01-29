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
@onready var door_toggle: TileMapLayer = $TerrainContainer/door_toggle

func start_level():
	door_toggle.visible = false
	door_toggle.collision_enabled = false
	print("starting level 2")

# Called when the node enters the scene tree for the first time.
func _ready():
	door_toggle.visible = false
	door_toggle.collision_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mrs_melodie_ready_to_fight() -> void:
	print("Mrs_Melodie Boss Ready!")
	door_toggle.visible = true
	door_toggle.collision_enabled = true
	boss_start_fight_gui_update.emit()

func _on_mrs_melodie_boss_dead() -> void:
	level_complete.emit()
	boss_death_gui_update.emit()

func _on_mrs_melodie_take_damage(damage: Variant) -> void:
	boss_health_gui_update.emit(-damage)
