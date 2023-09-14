# Autoloaded script/singleton
# Added to the root location
# Manages game states
extends Node

const PORT : int = 1337

@onready var main : Node = get_tree().root.get_node("Main")
@onready var players : Node = main.get_node("Players")
@onready var targets : Node = main.get_node("Targets")

var menu : Control = null
var map : Node = null


func _ready():
	menu = preload("res://scenes/menu.tscn").instantiate()
	main.add_child(menu)
	
	# if multiplayer.is_server():
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)

func load_map():
	# Free old stuff.
	if map != null:
		map.queue_free()
	if menu != null:
		menu.queue_free()
	
	# Spawn map.
	map = preload("res://scenes/map.tscn").instantiate()
	main.add_child(map)
	
	# if multiplayer.is_server():
	spawn_player(multiplayer.get_unique_id())
	spawn_target(0)

func spawn_player(id: int):
	var player = preload("res://scenes/player.tscn").instantiate()
	player.peer_id = id
	player.position = get_random_position()
	player.character_tile = get_random_character_tile()
	players.add_child(player, true)
	player.rpc("hello", "spawned player " + str(player.peer_id))

func spawn_target(type):
	var target = preload("res://scenes/target.tscn").instantiate()
	if type == 0:
		target.character_tile = Vector2i(6,1)
	else:
		target.character_tile = Vector2i(6,2)
	target.type = type
	target.position = get_random_position()
	targets.add_child(target)

func remove_player(id: int):
	if not players.has_node(str(id)):
		return
	players.get_node(str(id)).queue_free()

func get_random_position():
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rndX = rng.randi_range(0, screenSize.x)
	var rndY = rng.randi_range(0, screenSize.y / 2)
	return Vector2(rndX, rndY)

func get_random_character_tile():
	const character_tiles = [
		Vector2i(0, 0), Vector2i(2, 0), Vector2i(4, 0), Vector2i(6, 0),
		Vector2i(0, 1), Vector2i(4, 1), Vector2i(6, 1), Vector2i(3, 2), Vector2i(6, 2)
	]
	var rand_index:int = randi() % character_tiles.size()
	return character_tiles[rand_index]


# RPC methods
func hello(_from: String):
	pass
