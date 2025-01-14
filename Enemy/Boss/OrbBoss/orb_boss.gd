class_name OrbBoss
extends Boss

var anim_player :AnimationPlayer
var sprite : Sprite2D
var collider : CollisionShape2D 

var is_mimic: bool = false
var is_ready : bool = false
var facing_changed: bool = false

#Audio Stream Setup
@export var bally_laugh: AudioStream
@export var bally_hurt: AudioStream

@export var current_phase : int = 1

@export var facing: int = 1
signal take_damage(damage)
#signal enter_phase_2
signal ready_to_fight
signal create_mimic(pos)

@export var player_position : Vector2 = Vector2.ZERO
@export var move_target_container : Node2D

var move_targets : Array[Node]
var move_position :Vector2 = Vector2.ZERO

@export var min_idle_timer:  float = 5.0
@export var max_idle_timer: float = 0.5
var idle_timer : float = 0.0
@export var move_speed : float = 40
@export var bite_range : Vector2 = Vector2(50,50)
@export var health : int = 100
const max_health : int = 100
@onready var projectile_prefab = preload("res://Enemy/Boss/OrbBoss/projectile_orb.tscn")

enum boss_states {
	idle_human,
	idle_monster,
	splitting,
	laughing,
	transform,
	move,
	hurt,
	death,
	bite,
	projectile,
	destroy_object
	}
	
func _init():
	super()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	anim_player = $AnimationPlayer
	collider = $CollisionShape2D
	move_targets = move_target_container.get_children()
	
	
	if is_mimic: _set_state(boss_states.idle_monster)
	
	else:
		_set_state(boss_states.idle_human)
		$ReadyTimer.start()
		pick_move_target()
		position = move_position
		#$"MimicTimer".start()
		
	print(sprite.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _set_state(new_state) -> void:
	super(new_state)
	
func _on_state_tick(state, delta) -> void:
	super(state, delta)
	set_facing_player()
	
	if state == boss_states.idle_monster:
		#check if idle timer triggers
		if idle_timer <= 0:
			pick_attack_pattern()
		else:
			idle_timer -= delta
		
		#set facing and anim
		if facing_changed:
			var anim_position = anim_player.current_animation_position
			if facing == 1: 
				anim_player.play("idle2_right")
			else: anim_player.play("idle2_left")
			anim_player.seek(anim_position)
	
	if state == boss_states.move:
		if player_in_bite_range():
			_set_state(boss_states.bite)
		var relative_pos = move_position - position
		if relative_pos.length() < 1:
			_set_state(boss_states.idle_monster)
		else:
			var dir = relative_pos.normalized()
			var speed = move_speed
			move_and_collide(dir * speed*delta)
			if facing_changed:
				var anim_position = anim_player.current_animation_position
				if facing == 1: 
					anim_player.play("idle2_right")
				elif facing ==-1 : anim_player.play("idle2_left")
				else:
					anim_player.play("idle_up")
				anim_player.seek(anim_position)
		
		
		
		
func _on_state_enter(state) -> void:
	print(name, " State: " , boss_states.keys()[state])
	super(state)
	if state == boss_states.idle_human:
		anim_player.play("idle")
	if state == boss_states.idle_monster:
		idle_timer = randf_range(min_idle_timer, max_idle_timer)
		
	if state == boss_states.transform:
		anim_player.play("transform")
		AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballytransform1.wav")
		AudioPlayer.play_music("res://Assets/Audio/music/worm boss updated drums.mp3", 0.2, true)
		
	if state == boss_states.splitting:
		anim_player.play("splitting")
		AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballysplit.wav")
	if state == boss_states.laughing:
		anim_player.play("laughing")
		AudioPlayer.play_stream(bally_laugh)
	if state == boss_states.death:
		anim_player.play("death")
		AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballydeath1.wav")
	if state== boss_states.destroy_object:
		queue_free()
		
	if state == boss_states.move:
		if near_move_target():
			pick_move_target()

	if state == boss_states.bite:
		if facing ==-1:
			anim_player.play("bite_left")
			AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballychomp1.wav")
		else: anim_player.play("bite_right")
		AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballychomp1.wav")
		
	if state == boss_states.projectile:
		if facing ==-1:
			anim_player.play("projectile_left")
			print('pojectile left')
			AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballyshoot1.wav")
		elif facing == 1 : 
			anim_player.play("projectile_right")
			print('pojectile right')
			AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballyshoot1.wav")
		else: 
			anim_player.play("projectile_up")
			print('pojectile up')
			AudioPlayer.play_sound("res://Assets/Audio/enemy/ball boss/yoyo_ballyshoot1.wav")
		create_projectile()
		
		
		
		
		
	
func _on_state_exit(state) -> void:
	super(state)
	
	if current_state  == boss_states.splitting:
		create_mimic.emit($MimicSpawnLocation.position + position)

func on_take_damage(damage):
	AudioPlayer.play_stream(bally_hurt, 0.5)
	AudioPlayer.play_sound("res://Assets/Audio/enemy/yoyo_enemyhit1.wav", 0.75)
	if is_mimic:
		_set_state(boss_states.death)
		print("Mimic Destroyed")
	else:
		print("Orb Boss Took Damage: " , damage)
		take_damage.emit(damage)
	

func _on_area_2d_body_entered(body) -> void:
	if body is Yoyo:
		var damage = body.yoyo_stats.base_damage
		on_take_damage(damage)
	#TODO: impliment player death on touching boss
	if body is Player:
		print("PLAYER SHOULD DIE NOW!!!!!!!!")
		
func set_facing_player() -> void:
	var new_facing : int
	if player_position.y > abs(player_position.x) and (player_position.y - position.y) > 0:
		new_facing = 0
	else:	
		if player_position.x < position.x:
			new_facing = -1
		else : 
			new_facing  = 1
		
	if new_facing != facing:
		facing_changed = true
		print(facing)
		facing = new_facing
	else: facing_changed = false


func _on_ready_timer_timeout():
	if !is_mimic:
		_set_state(boss_states.transform)
		ready_to_fight.emit()


func _on_animation_player_animation_finished(anim_name):

		
	if current_state == boss_states.death:
		_set_state(boss_states.destroy_object)
		
	if current_state == boss_states.bite:
		if near_move_target():
			_set_state(boss_states.idle_monster)
		else:
			_set_state(boss_states.move)
		
	if (current_state == boss_states.laughing or 
			current_state == boss_states.splitting or 
			current_state == boss_states.transform or
			current_state == boss_states.projectile
			): 
		_set_state(boss_states.idle_monster)
	
# Timer to test mimic
#func _on_mimic_timer_timeout():
	#print(name, " split timeout")
	#_set_state(boss_states.splitting)

func pick_move_target() -> void:
	move_position = move_targets.pick_random().position
	
func pick_attack_pattern():
	var i = randf_range(0,1) 
	if i < 0.45:
		_set_state(boss_states.move)
	elif i < 0.9 : _set_state(boss_states.projectile)
	else : _set_state(boss_states.laughing)
	
func player_in_bite_range() -> bool:
	return abs(player_position.x - position.x) < bite_range.x and abs(player_position.y - position.y) < bite_range.y
	
	
func create_projectile():
	var projectile = projectile_prefab.instantiate()
	projectile.position = position
	if facing == 0:
		projectile.position.y += 25
	else: projectile.position.x += 25*facing
	get_parent().add_child(projectile)
	var dir = (player_position - position).normalized()
	projectile.launch(dir)
	
func near_move_target() -> bool:
	return (position - move_position).length() < 10
