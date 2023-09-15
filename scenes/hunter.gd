extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
		var tilemap: TileMap = get_node("HunterTileMap")
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

func _physics_process(_delta):
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

	var collision = get_last_slide_collision()
	if collision:
		if collision.get_collider().get_parent().type == get_node("/root/Game").types.ACC:
			#print("Collided with accelerator")
			pass
		else:
			#print("Collided with decelerator")
			pass
	#for i in get_slide_collision_count():
	#	var collision = get_slide_collision(i)
	#	print("Collided with: ", collision.collider.name)
