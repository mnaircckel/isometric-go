extends TileMap

var bomb_index = 35
var indestructible_indices = [0,27,28,29,30,31,32,33,34]
var bomb_handler

func _ready():
	bomb_handler = get_node("Bombs")
	
func walkable_tile(location):
	return !(location in get_used_cells())

func place_bomb(location, bomb_strength):
	bomb_handler.add_bomb(location, bomb_strength)

func is_destructible(index):
	return !(index in indestructible_indices)

func get_object_index(location):
	return get_cell(location.x,location.y)

	