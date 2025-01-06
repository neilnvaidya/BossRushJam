extends Node2D

@onready var player = $Player
@onready var weapon = $Weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	set_line_points()

func set_line_points():
	$Line2D.clear_points()
	$Line2D.add_point($Player.position)  # Start point is weapon's position (local space)
	$Line2D.add_point($Weapon.position)  # Line to weapon head
