extends Boss

var anim_player :AnimationPlayer
var sprite : Sprite2D
var collider : CollisionShape2D 

@export var facing: int = 1

enum boss_states {
	idle_human,
	idle_monster,
	splitting,
	laughing,
	transform,
	hurt,
	death,
	bite,
	projectile
	}
	
func _init():
	super()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	anim_player = $AnimationPlayer
	collider = $CollisionShape2D
	
	_set_state(boss_states.idle_human)
	print(sprite.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_state(new_state):
	super(new_state)
	
func _on_state_tick(state):
	super(state)
	
func _on_state_enter(state):
	super(state)
	if state == boss_states.idle_human:
		anim_player.play("idle")
		
	# TODO: implement facing 
	if state ==boss_states.idle_monster:
		anim_player.play("idle2")

func _on_state_exit(state):
	super(state)

func _on_area_2d_body_entered(body):
	print('body entered :' , body.name)
	if body is Yoyo:
		print(body.yoyo_stats.base_damage)
