extends TileMap

func _ready():
	pass
	
func walkable_tile(location):
	return !(location in get_used_cells())


