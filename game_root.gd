extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Create client and connect to server.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_accelerator_area_entered(area):
	var you = area.name
	print("Yay! " + you + " Hit Accelerator area")

	var acc = get_node("AcceleratorRoot")
	acc.new_pos()


func _on_decelerator_area_entered(area):
	var you = area.name
	print("Noes! " + you + " Hit Decelerator area")

	var dec = get_node("DeceleratorRoot")
	dec.new_pos()
