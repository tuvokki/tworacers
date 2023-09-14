extends Node2D

const GRAVITY = 30.0
const SPEED = 15.0
const JUMP_VELOCITY = 10.0
var _accelerator = 1

# Peer id.
@export var peer_id : int : 
	set(value):
		peer_id = value
		name = str(peer_id)
		$Label.text = str(peer_id)
		set_multiplayer_authority(peer_id)

# Character tile.
@export var character_tile : Vector2i :
	set(value):
		character_tile = value
		var tilemap: TileMap = get_node("TileMap")
		tilemap.set_cell(0, Vector2i(0, 0), 1, character_tile)

@rpc("any_peer")
func hello(from: String):
	print("[" + str(peer_id) + "] Hello from: " + from)

func _ready():
	# Set process functions for current player.
	var is_local = is_multiplayer_authority()
	set_process_input(is_local)
	set_physics_process(is_local)
	set_process(is_local)

func _process(_delta):
	# Handle mouse capture.
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _input(event):	
	if(event.is_action("move_right")):
		move_local_x(SPEED * _accelerator)
	if(event.is_action("move_left")):
		move_local_x(-SPEED * _accelerator)
	if(event.is_action("move_forward")):
		move_local_y(-SPEED * _accelerator)
	if(event.is_action("move_backward")):
		move_local_y(SPEED * _accelerator)

func accelerate():
	print("Accelerating to " + str(_accelerator + 1))
	if (_accelerator < 5):
		_accelerator = _accelerator + 1

func decelerate():
	print("Decelerating to " + str(_accelerator - 1))
	if (_accelerator > 1):
		_accelerator = _accelerator - 1

# Called during every input event.
func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_action_just_pressed("ui_accept"):
				print(get_process_delta_time())
