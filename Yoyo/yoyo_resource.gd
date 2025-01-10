class_name YoyoStats
extends Resource

@export_group("Card Attributes")

@export var id: String
@export_multiline var tootip_text: String
@export var sound: AudioStream
@export var base_damage : int

@export_group("Card Visuals")
@export var icon: Texture

func apply_effects() -> void:
	pass

func get_default_tooltip()->String:
	return tootip_text
