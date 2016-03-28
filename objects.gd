extends TileMap

var bomb_index = 35
var bombs

func _ready():
	bombs = get_node("Bombs")
	
func walkable_tile(location):
	return !(location in get_used_cells())

func place_bomb(location):
	bombs.add_bomb(location)

