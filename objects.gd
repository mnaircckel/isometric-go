extends TileMap

var bomb_index = 35
	
func walkable_tile(location):
	return !(location in get_used_cells())

func place_bomb(location):
	set_cell(location.x, location.y, bomb_index)


