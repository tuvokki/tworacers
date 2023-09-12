extends Node2D

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_pos():
	move_local_x(random.randi_range(-50, 50))
	move_local_y(random.randi_range(-50, 50))
