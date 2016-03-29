extends Node2D

# Game constants
var TILE_SIZE_X = 64
var TILE_SIZE_Y = 32
var DISTANCE_LEFT = Vector2(-TILE_SIZE_X, TILE_SIZE_Y)
var DISTANCE_RIGHT = Vector2(TILE_SIZE_X, -TILE_SIZE_Y)
var DISTANCE_UP = Vector2(-TILE_SIZE_X, -TILE_SIZE_Y)
var DISTANCE_DOWN = Vector2(TILE_SIZE_X, TILE_SIZE_Y)
var GAME_TICK = .5

# Game variables
var level
var hud
var object_handler

func _ready():
	# See objects.gd for object_handler code
	object_handler = get_node("ObjectMapHandler")
	load_level("level_one.scn")
	load_hud("hud.scn")
	

# Load a level from a scene
# Levels must include a TileMap called ObjectMap (Used for objects)
func load_level(level_name):
	level = load(level_name).instance()
	add_child(level)
	move_child(level, 0)
	object_handler.clear()
	object_handler.load_objects(level.get_node("ObjectMap"))

# Load hud from a scene
func load_hud(hud_name):
	hud = load(hud_name).instance()
	add_child(hud)
	