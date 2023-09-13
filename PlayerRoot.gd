extends Node2D

var _speed = 10
var _accelerator = 1
const IP_ADDRESS = "127.0.0.1"
const PORT = 8081
var _is_connected = false
var verticalMovement = 0
var speed = 10
const MAX_VERTICAL_MOVEMENT = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	_speed = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node("Player/Label").text = "Accelerator: " + str(_accelerator)
	if !_is_connected:
		# Create client.
		var peer = ENetMultiplayerPeer.new()
		peer.create_client(IP_ADDRESS, PORT)
		multiplayer.multiplayer_peer = peer
		var peer_id = peer.get_unique_id()
		print("Client peerId: " + str(peer_id))
		_is_connected = true
		$"/root/Lobby"._register_player.rpc()
	else:
		get_node("Player").visible = true

func move(event, speed = _speed):
	if(event.is_action("PLAYER_RIGHT")):
		move_local_x(speed * _accelerator)
	if(event.is_action("PLAYER_LEFT")):
		move_local_x(-speed * _accelerator)
	if(event.is_action("PLAYER_UP")):
		move_local_y(-speed * _accelerator)
	if(event.is_action("PLAYER_DOWN")):
		move_local_y(speed * _accelerator)

func accelerate():
	print("Accelerating to " + str(_accelerator + 1))
	if (_accelerator < 5):
		_accelerator = _accelerator + 1

func decelerate():
	print("Decelerating to " + str(_accelerator - 1))
	if (_accelerator > 1):
		_accelerator = _accelerator - 1

func _input(event):
	move(event)

# Called during every input event.
func _unhandled_input(event):
	match event.get_class():
		"InputEventKey":
			if Input.is_action_just_pressed("ui_accept"):
				print(get_process_delta_time())


func _on_tree_entered():
	print("Player enetered tree.")
