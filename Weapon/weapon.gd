extends Node2D

@export var neutral_distance: float = 50.0  # Neutral spring length
@export var max_distance: float = 200.0  # Maximum allowable distance
@export var elasticity: float = 2.0  # Spring stiffness
@export var damping: float = 0.997  # Friction-like effect

@export var spring_force: Vector2 = Vector2.ZERO  # Current calculated spring force (exported for debugging)

var velocity: Vector2 = Vector2.ZERO  # Weapon's velocity

func _physics_process(delta):
	var player_position = get_parent().player.position
	var to_player = player_position - position
	var distance = to_player.length()
	var radial_velocity = velocity.project(to_player)
	var tangential_velocity = velocity - radial_velocity
	
	velocity = apply_spring_force(velocity,delta, to_player, distance)
	
	## Constrain to max distance
	if distance + velocity.length()*delta >= max_distance:
		position = player_position - to_player.normalized()*max_distance

	# Apply damping to reduce velocity over time
	#velocity *= damping

	# Update position based on velocity
	position += velocity * delta

	# Update spring force visualization
	set_spring_force_line()
	
func apply_spring_force(vel, delta, to_player, distance):
	# Apply spring force if distance > neutral_distance
	if distance > neutral_distance:
		var stretch = distance - neutral_distance
		spring_force = to_player.normalized() * elasticity * stretch
		vel += spring_force * delta
	else:
		spring_force = Vector2.ZERO  # No spring force if within neutral range
	return vel
	
func set_spring_force_line():
	# Visualize the spring force with Line2D
	$Line2D.clear_points()
	$Line2D.add_point(Vector2.ZERO)  # Start at weapon's position
	$Line2D.add_point(spring_force / elasticity)  # Scaled force vector for visualization
