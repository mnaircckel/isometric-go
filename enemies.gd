extends Node2D

const Enemy = preload("enemy.scn")
var game
var spawn = true

func _ready():
	game = get_tree().get_root().get_node("Game")
	set_process(true)

func _process(delta):
	if spawn:
		spawn_enemy(Vector2(0,0))
		spawn = false

func spawn_enemy(location):
	var new_enemy = Enemy.instance()
	game.add_child(new_enemy)
	




