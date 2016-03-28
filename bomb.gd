extends Node2D

# Bomb constants
var bomb_cycle = .1
var last_frame = 16

# Bomb variables
var location
var current_frame
var bomb_timer
var bombs
var object_map

# Create new bomb
func _init(location, object_map):
	self.location = location
	self.current_frame = 0
	self.bomb_timer = 0
	self.object_map = object_map
	object_map.set_cell(location.x, location.y, object_map.bomb_index + current_frame)

# Update called from bomb handler every frame
func update(delta):
	bomb_timer += delta
	update_animation()

# Animations
func update_animation():
	if bomb_timer > bomb_cycle:
		current_frame += 1
		bomb_timer = 0
		if current_frame > last_frame:
			current_frame = 0
		object_map.set_cell(location.x, location.y, object_map.bomb_index + current_frame)
