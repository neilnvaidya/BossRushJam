class_name OrbBoss
extends Boss

var anim_player :AnimationPlayer
var sprite : Sprite2D
var collider : CollisionShape2D 

var is_mimic: bool = false
var is_ready : bool = false

@export var current_phase : int = 1

@export var facing: int = 1
signal take_damage(damage)
#signal enter_phase_2
signal ready_to_fight
signal create_mimic(pos)

@export var player_position : Vector2 = Vector2.ZERO

enum boss_states {
	idle_human,
	idle_monster,
	splitting,
	laughing,
	transform,
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
	
	if is_mimic: _set_state(boss_states.idle_monster)
	
	else:
		_set_state(boss_states.idle_human)
		$ReadyTimer.start()
		$"MimicTimer".start()
		
	print(sprite.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _set_state(new_state):
	super(new_state)
	
func _on_state_tick(state):
	super(state)
	if state == boss_states.idle_monster:
		set_facing_player()
		
	
func _on_state_enter(state):
	print(name, " State: " , boss_states.keys()[state])
	super(state)
	if state == boss_states.idle_human:
		anim_player.play("idle")
		
	if state == boss_states.idle_monster:
		if facing == 1: anim_player.play("idle2_right")
		else: anim_player.play("idle2_left")
		
	if state == boss_states.transform:
		anim_player.play("transform")
	if state == boss_states.splitting:
		anim_player.play("splitting")
	
	if state == boss_states.death:
		anim_player.play("death")
		
	if state== boss_states.destroy_object:
		queue_free()
		
	
func _on_state_exit(state):
	super(state)
	if current_state  == boss_states.splitting:
		create_mimic.emit($MimicSpawnLocation.position + position)

func on_take_damage(damage):
	if is_mimic:
		_set_state(boss_states.death)
		print("Mimic Destroyed")
	else:
		print("Orb Boss Took Damage: " , damage, " --- not coded")
		take_damage.emit(damage)
	

func _on_area_2d_body_entered(body):
	if body is Yoyo:
		var damage = body.yoyo_stats.base_damage
		on_take_damage(damage)
		
# TODO: get the relative facing and do proper 
#		checks for the correct idle animation
#		Want to check the quadrant and apply correct animation.
#		use current_animation_posion and seek() to match anims
func set_facing_player():
	if player_position.x < position.x:
		facing = -1
	else : facing  = 1


func _on_ready_timer_timeout():
	if !is_mimic:
		_set_state(boss_states.transform)
		ready_to_fight.emit()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "transform" and current_state == boss_states.transform:
		_set_state(boss_states.idle_monster)
	if anim_name == "splitting" and current_state == boss_states.splitting:
		_set_state(boss_states.idle_monster)
		
	if anim_name == "death" and current_state == boss_states.death:
		_set_state(boss_states.destroy_object)
	
	
func _on_mimic_timer_timeout():
	print(name, " split timeout")
	_set_state(boss_states.splitting)
