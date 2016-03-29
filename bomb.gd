extends Node2D

# Bomb constants
var bomb_cycle = .12
var last_frame = 16
var explosion_frame = 7

# Bomb variables
var location
var current_frame
var bomb_strength
var bomb_timer
var object_map
var live
var to_explode

# Create new bomb
func _init(location, bomb_strength, object_map):
	self.bomb_strength = bomb_strength
	self.location = location
	self.current_frame = 0
	self.bomb_timer = 0
	self.object_map = object_map
	self.live = true
	self.to_explode = []
	object_map.set_cell(location.x, location.y, object_map.bomb_index + current_frame)

# Update called from bomb handler every frame
func update(delta):
	bomb_timer += delta
	update_bomb()

# Explode tiles
func explode(frame):
	for tile in to_explode:
		object_map.set_cell(tile.x, tile.y, frame)

# Calculate which tiles to explode
func calcuate_range():
	# Current location
	to_explode.push_back(location)
	# Various directions
	add_tiles_to_explode("down")
	add_tiles_to_explode("up")
	add_tiles_to_explode("left")
	add_tiles_to_explode("right")	

# Bombs will explode in a direction until they hit an object
func add_tiles_to_explode(direction):
	var offset_location
	for offset in range(1,bomb_strength+1,1):
		# Calculate location based on direction
		if direction == "down":
			offset_location = Vector2(location.x + offset, location.y)
		elif direction == "up":
			offset_location = Vector2(location.x - offset, location.y)
		elif direction == "left":
			offset_location = Vector2(location.x, location.y + offset)
		elif direction == "right":
			offset_location = Vector2(location.x, location.y - offset)
		# Check if the tile contains an object
		# And add the tile to to_explode accordingly
		if object_map.walkable_tile(offset_location):
			to_explode.push_back(offset_location)
		elif bomb_can_destroy(offset_location):
			to_explode.push_back(offset_location)
			break
		else:
			break

func bomb_can_destroy(location):
	return object_map.is_destructible(object_map.get_object_index(location))

# Animations and updates
func update_bomb():
	if bomb_timer > bomb_cycle:
		current_frame += 1
		bomb_timer = 0
		if current_frame > last_frame:
			current_frame = last_frame
			explode(-1)
			self.live = false
		elif current_frame > explosion_frame:
			explode(object_map.bomb_index + current_frame)
		elif current_frame == explosion_frame:
			calcuate_range()
		else:
			object_map.set_cell(location.x, location.y, object_map.bomb_index + current_frame)
			