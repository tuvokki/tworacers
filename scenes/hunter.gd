extends CharacterBody2D


const SPEED = 100.0
const SPEED_BUMP: int = 50
var _accelerator: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Peer id.
@export var peer_id : int : 
	set(value):
		peer_id = value
		name = "Hunter " + str(peer_id)
		#$Label.text = str(peer_id)
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
	add_to_group("hunters")

func _process(_delta):
	var accelerated_SPEED = SPEED + _accelerator
	$Label.text = str(accelerated_SPEED)
	if accelerated_SPEED <= 0:
		get_node("/root/Main/Label").text = name + " Lost"
		get_node("/root/Main/Label").show()


func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var accelerated_SPEED = SPEED + _accelerator
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * accelerated_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.y = direction * accelerated_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

	var collision = get_last_slide_collision()
	if collision:
		if collision.get_collider().name == "TargetTileMap":
			if collision.get_collider().get_parent().name == "Accelerator":
				if _accelerator < 200:
					_accelerator += SPEED_BUMP
			if collision.get_collider().get_parent().name == "Decelerator":
				if _accelerator > -100:
					_accelerator -= SPEED_BUMP
			collision.get_collider().get_parent().new_pos()
			
			#var targets = get_tree().get_nodes_in_group("targets")
			#for target in targets:
			#	print("Target: " + target.name + "\nCollider: " + collision.get_collider().get_parent().name + "\n\n")
		#if collision.get_collider().is_in_group("targets"):
		#	print("Hit target")
#		if collision.get_collider() == get_node("/root/Main/Targets/Target/TargetTileMap"):
#			print("Hit target")
#			var collider_target = collision.get_collider().get_parent()
#			if collider_target.type == Game.types.ACC:
#				if _accelerator < 250:
#					_accelerator += 50
#			if collider_target.type == Game.types.DEC:
#				if _accelerator > 0:
#					_accelerator -= 50

func _on_mouse_entered():
	$Label.show()

func _on_mouse_exited():
	$Label.hide()
