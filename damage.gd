extends Node2D

var game
var player
var enemies

func _ready():
	game = get_parent()
	player = game.get_node("Player")
	enemies = game.get_node("Level").get_node("Enemies")

func deal_damage_at_tile(location, amount):
	# Player
	if player.current_tile == location:
		player.take_damage(amount)
	# Enemies
	for enemy in enemies.get_children():
		if enemy != null:
			if enemy.current_tile == location:
				enemy.take_damage(amount)
	