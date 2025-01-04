extends Area2D

@export var damage: int
@export var weight: int
@export var min_radius: int
@export var max_radius: int
@export var min_speed: float
@export var max_speed: float
@export var current_speed: float = 0.0

# Circular motion parameters
var angle: float = 0.0  # Current angle in radians

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Initialized Weapon - ", name, 
		  ":\n   Damage: ", damage, " | Weight: ", weight)
	position = Vector2(0, min_radius)  # Start at min_radius along the y-axis
	current_speed = min_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	angle += current_speed * delta  # Increment the angle based on speed and delta time
	position.x = cos(angle) * min_radius  # Update x-coordinate
	position.y = sin(angle) * min_radius  # Update y-coordinate

func _on_area_entered(area):
	# Calling directly is sloppy, 
	# will be better to set up signals
	# and a manager to handle enemy recieving damage.
	area.on_hit(damage)
