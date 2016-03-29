extends TileMap

# TileMap variables
var bomb_index = 35
var indestructible_indices = [0,27,28,29,30,31,32,33,34]
var bomb_handler

func _ready():
	bomb_handler = get_node("Bombs")

# Place bomb into ObjectMap
func place_bomb(location, bomb_strength):
	bomb_handler.add_bomb(location, bomb_strength)

# Utility functions
func walkable_tile(location):
	return !(location in get_used_cells())

func is_destructible(index):
	return !(index in indestructible_indices)

func get_object_index(location):
	return get_cell(location.x,location.y)

# Load objects based on a Tilemap (usually called by game.gd to load a level)
func load_objects(objects):
	var object_locations = objects.get_used_cells()
	for object_location in object_locations:
		var object_type = objects.get_cell(object_location.x, object_location.y)
		set_cell(object_location.x, object_location.y, object_type)
