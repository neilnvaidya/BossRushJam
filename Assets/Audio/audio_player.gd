extends Node

#Script created by Silvyger aka Silver

@export var MUSIC_BUS : StringName = "Music"
@export var SOUND_BUS : StringName = "Sound"
@export var YOYO_BUS : StringName = "YoYoLoop"

@export_subgroup("Default Configuration")
@export var music_process : ProcessMode = PROCESS_MODE_ALWAYS
@export var sound_process : ProcessMode = PROCESS_MODE_PAUSABLE

func play_sound(sound_path: String, volume: float = 1.0) -> AudioStreamPlayer:
	return play_stream(load(sound_path), volume)

func play_yoyoloop(sound_path: String, volume: float = 1.0) -> AudioStreamPlayer:
	return play_yoyostream(load(sound_path), volume)

func play_sound_at_point(sound_path: String, position: Vector2, volume: float = 1.0) -> AudioStreamPlayer2D:
	return play_stream_at_point(load(sound_path), position, volume)

func play_stream(stream : AudioStream, volume : float = 1.0) -> AudioStreamPlayer:
	var audio_player := _create_default_sound_player()
	audio_player.stream = stream
	audio_player.volume_db = linear_to_db(volume)
	add_child(audio_player)
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.play()
	return audio_player
	
func play_yoyostream(stream : AudioStream, volume : float = 1.0) -> AudioStreamPlayer:
	var audio_player := _create_yoyo_sound_player()
	audio_player.stream = stream
	audio_player.volume_db = linear_to_db(volume)
	add_child(audio_player)
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.play()
	return audio_player

func play_stream_at_point(stream : AudioStream, position: Vector2, volume: float = 1.0) -> AudioStreamPlayer2D:
	var audio_player := _create_default_sound_player_2d()
	audio_player.stream = stream
	audio_player.volume_db = linear_to_db(volume)
	add_child(audio_player)
	audio_player.global_position = position
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.play()
	return audio_player

func play_music(music_path: String, volume: float = 1.0, looping: bool = true) -> AudioStreamPlayer:
	var audio_player := _create_default_music_player()
	audio_player.set_meta("is_music", true)
	audio_player.stream = load(music_path)
	audio_player.volume_db = linear_to_db(volume)
	if "loop" in audio_player.stream:
		audio_player.stream = audio_player.stream.duplicate()
		audio_player.stream.loop = looping
	if not looping:
		audio_player.finished.connect(audio_player.queue_free)
	add_child(audio_player)
	audio_player.play()
	return audio_player

func stop_audio(audio_player: AudioStreamPlayer, fade_duration: float) -> Tween:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(audio_player, "volume_db", -70, fade_duration)
	tween.finished.connect(audio_player.queue_free)
	return tween

func stop_all_sounds():
	for child in get_children():
		if child.get_meta("is_music"): continue
		
		stop_audio(child, 2)
	pass

func _create_default_music_player() -> AudioStreamPlayer:
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = MUSIC_BUS
	audio_player.process_mode = music_process
	return audio_player

func _create_default_sound_player() -> AudioStreamPlayer:
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = SOUND_BUS
	audio_player.process_mode = sound_process
	return audio_player
	
func _create_yoyo_sound_player() -> AudioStreamPlayer:
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = YOYO_BUS
	audio_player.process_mode = sound_process
	return audio_player

func _create_default_sound_player_2d() -> AudioStreamPlayer2D:
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.bus = SOUND_BUS
	audio_player.process_mode = sound_process
	audio_player.max_distance = 1200
	audio_player.attenuation = 1.0
	return audio_player
