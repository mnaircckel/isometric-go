extends Node2D

# Game constants
const TILE_SIZE_X = 64
const TILE_SIZE_Y = 32
const DISTANCE_LEFT = Vector2(-TILE_SIZE_X, TILE_SIZE_Y)
const DISTANCE_RIGHT = Vector2(TILE_SIZE_X, -TILE_SIZE_Y)
const DISTANCE_UP = Vector2(-TILE_SIZE_X, -TILE_SIZE_Y)
const DISTANCE_DOWN = Vector2(TILE_SIZE_X, TILE_SIZE_Y)
const GAME_TICK = .5
const LEVEL_TIMES = [300]
# Preload scenes
const MainMenu = preload("main_menu.scn")
# Game variables
var level
var time = 0
var hud
var object_handler

func _ready():
	# See objects.gd for object_handler code
	object_handler = get_node("ObjectMapHandler")
	load_level("level_one.scn", 0)
	load_hud("hud.scn")
	set_process_input(true)
	set_process(true)

func _process(delta):
	time -= delta
	if time <= 0:
		game_over()

func _input(event):
	if Input.is_action_pressed("ui_exit") and !event.is_echo():
		quit_to_main_menu()

func get_time_left():
	return time

# Get time requirement for level
func get_level_time(level):
	return LEVEL_TIMES[level]

# Load a level from a scene
# Levels must include a TileMap called ObjectMap (Used for objects)
func load_level(level_name, level_index):
	level = load(level_name).instance()
	time = get_level_time(level_index)
	add_child(level)
	move_child(level, 0)
	object_handler.clear()
	object_handler.load_objects(level.get_node("ObjectMap"))

# Load hud from a scene
func load_hud(hud_name):
	hud = load(hud_name).instance()
	add_child(hud)

func quit_to_main_menu():
	var menu_scene = MainMenu.instance()
	menu_scene.active_game = true
	get_tree().get_root().add_child(menu_scene)
	get_tree().set_pause(true)

func game_over():
	load_hud("game_over.scn")
	get_tree().set_pause(true)
	