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

func update_bombs(delta):
	for bomb in bombs:
		bomb.update(delta)

