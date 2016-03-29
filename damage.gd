extends Node2D

var game
var player
var enemies

func _ready():
	game = get_parent()
	player = game.get_node("Player")

func deal_damage_at_tile(location, amount):
	# Player
	if player.current_tile == location:
		player.take_damage(amount)
	# Enemies
	# TODO




