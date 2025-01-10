extends Node
@export var game_scene:String
var game_world:Node2D

func _on_game_starting():
	print("Change")
	await $MainMenu.tree_exited
	game_world = load(game_scene).instantiate()
	add_child(game_world)
