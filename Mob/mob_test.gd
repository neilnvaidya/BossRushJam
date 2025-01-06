extends Area2D

var damage_taken = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_hit(damage):
	damage_taken += damage
	print(name, " : GOT HIT ", damage_taken)
	
