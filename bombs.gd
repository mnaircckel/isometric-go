extends Node2D

# Bomb handler variables
var object_map
var bombs = []

func _ready():
	set_process(true)
	object_map = get_parent()

func _process(delta):
	update_bombs(delta)

func add_bomb(location):
	var bomb = preload("res://bomb.gd").new(location, object_map)
	bombs.push_back(bomb)

# Iterative through all active bombs and update them
func update_bombs(delta):
	var to_delete = []
	var index = 0
	for bomb in bombs:
		bomb.update(delta)
		if !bomb.live:
			to_delete.push_back(index)
		index += 1
	clean_up_bombs(to_delete)

# For bombs that aren't live, remove them from the list of bombs
func clean_up_bombs(to_delete):
	for bomb_index in to_delete:
		bombs.remove(bomb_index)
		# Unsure if it is needed to manually free the bomb from the scene
		# Because it is not connected to any other nodes

