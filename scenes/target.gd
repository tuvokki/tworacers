extends Node2D

var random = RandomNumberGenerator.new()
enum types {ACC,DEC}

# Target type.
@export var type : int :
	set(value):
		type = value

# Character tile.
@export var character_tile : Vector2i :
	set(value):
		character_tile = value
		var tilemap: TileMap = get_node("TileMap")
		tilemap.set_cell(0, Vector2i(0, 0), 1, character_tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func new_pos():
	move_local_x(random.randi_range(-50, 50))
	move_local_y(random.randi_range(-50, 50))
