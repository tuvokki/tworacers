extends StaticBody2D

var random = RandomNumberGenerator.new()

# Target type.
@export var type : int :
	set(value):
		type = value

# Character tile.
@export var character_tile : Vector2i :
	set(value):
		character_tile = value
		var tilemap: TileMap = get_node("TargetTileMap")
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

func _physics_process(_delta):
	pass
	#var velocity = Vector2( 0, 0 ) # no movement
	#var collision = move_and_collide(velocity, true)
	#if collision and collision.get_collider() == get_node("TargetTileMap"):
	#	# Are we the baddies now?
	#	var collision_target = collision.get_collider().get_parent().type
	#	print("Target Collision -> ", collision_target)
	#if collision and collision.get_collider() != get_node("TargetTileMap"):
	#	var collision_target = collision.get_collider().name # == the id of the player hitting
	#	print("!Target Collision -> ", collision_target)
	#	new_pos()
	
