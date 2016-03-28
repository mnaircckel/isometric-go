extends Node2D

# Bomb constants
var bomb_cycle = .12
var last_frame = 16
var explosion_frame = 8

# Bomb variables
var location
var current_frame
var bomb_strength
var bomb_timer
var bombs
var object_map
var live

# Create new bomb
func _init(location, bomb_strength, object_map):
	self.bomb_strength = bomb_strength
	self.location = location
	self.current_frame = 0
	self.bomb_timer = 0
	self.object_map = object_map
	self.live = true
	object_map.set_cell(location.x, location.y, object_map.bomb_index + current_frame)

# Update called from bomb handler every frame
func update(delta):
	bomb_timer += delta
	update_bomb()

# Explosion
func explode():
	var offset = -bomb_strength
	while offset <= bomb_strength:
		if bomb_can_destroy(Vector2(location.x + offset, location.y)):
			object_map.set_cell(location.x + offset, location.y, object_map.bomb_index + current_frame)
		if bomb_can_destroy(Vector2(location.x, location.y + offset)):
			object_map.set_cell(location.x, location.y + offset, object_map.bomb_index + current_frame)
		offset += 1

func bomb_can_destroy(location):
	return object_map.is_destructible(object_map.get_object_index(location))

func remove_explosions():
	var offset = -bomb_strength
	while offset <= bomb_strength:
		if bomb_can_destroy(Vector2(location.x + offset, location.y)):
			object_map.set_cell(location.x + offset, location.y, -1)
		if bomb_can_destroy(Vector2(location.x, location.y + offset)):
			object_map.set_cell(location.x, location.y + offset, -1)
		offset += 1

# Animations and updates
func update_bomb():
	if bomb_timer > bomb_cycle:
		current_frame += 1
		bomb_timer = 0
		if current_frame >= last_frame:
			current_frame = last_frame
			remove_explosions()
			self.live = false
		elif current_frame > explosion_frame:
			explode()
			pass
		else:
			object_map.set_cell(location.x, location.y, object_map.bomb_index + current_frame)

