extends Sprite

# Enemy variables
var game
var damage_handler
# Animation constants
const last_frame = 4
const animation_cycle = .15
# Animation variables
var animation_timer = 0
var current_frame = 0
# Movement
var moving = false
var movement_timer = 0
var direction = "none"
var direction_timer_length = 2
var direction_timer = 0
export var current_tile = Vector2(0,0)
var current_location
var target_location
# Health
var current_health = 1
var max_health = 1
# Damage
var damage = 1

# When enemy is loaded into scene
func _ready():
	set_process(true)
	game = get_tree().get_root().get_node("Game")
	damage_handler = game.get_node("DamageHandler")
	current_location = tile_to_pos()
	set_pos(current_location)
	target_location = current_location

# Process every frame
func _process(delta):
	animate(delta)
	move(delta)
	
# Convert tile into pixel position
func tile_to_pos():
	var pos_x = game.TILE_SIZE_X * (current_tile.x - current_tile.y)
	var pos_y = game.TILE_SIZE_Y * (current_tile.y + current_tile.x)
	return Vector2(pos_x, pos_y)

# Go random direction
func pick_random_direction():
	var rand = int(rand_range(0,5))
	if rand == 0:
		direction = "left"
	elif rand == 1:
		direction = "right"
	elif rand == 2:
		direction = "up"
	elif rand == 3:
		direction = "down"
	else:
		direction = "none"
		
	

# Handle movement based on target_location
func move(delta):
	# Choose where to go
	if !moving:
		movement_timer = 0
		
	direction_timer -= delta
	if direction_timer <= 0:
		direction_timer = direction_timer_length
		pick_random_direction()
	
	
	var object_map = game.get_node("ObjectMapHandler")
	if direction == "left" and !moving:
		move_target_left(object_map)
	elif direction == "right" and !moving:
		move_target_right(object_map)
	elif direction == "up" and !moving:
		move_target_up(object_map)
	elif direction == "down" and !moving:
		move_target_down(object_map)
		
	# Move
	var to_move = target_location-current_location
	if reached_target_location():
		if to_move == game.DISTANCE_LEFT:
			current_tile.y += 1
		elif to_move == game.DISTANCE_RIGHT:
			current_tile.y -= 1
		elif to_move == game.DISTANCE_UP:
			current_tile.x -= 1
		elif to_move == game.DISTANCE_DOWN:
			current_tile.x += 1
		if moving:
			damage_handler.damage_player(current_tile, damage)
		moving = false
		current_location = target_location
		set_pos(target_location)
	else:
		movement_timer += delta
		var percent_moved = movement_timer/game.GAME_TICK
		var to_x = current_location.x + percent_moved*to_move.x
		var to_y = current_location.y + percent_moved*to_move.y
		var moving_position = Vector2(to_x, to_y)
		set_pos(moving_position)

func reached_target_location():
	return movement_timer >= game.GAME_TICK or current_location == target_location

# If walkable direction, move target and update animation
func move_target_left(object_map):
	set_animation_left()
	var target_tile = Vector2(current_tile.x, current_tile.y+1)
	if object_map.walkable_tile(target_tile):
		moving = true
		target_location = current_location+game.DISTANCE_LEFT
	else:
		pick_random_direction()
	
func move_target_right(object_map):
	set_animation_right()
	var target_tile = Vector2(current_tile.x, current_tile.y-1)
	if object_map.walkable_tile(target_tile):
		moving = true
		target_location = current_location+game.DISTANCE_RIGHT
	else:
		pick_random_direction()

func move_target_up(object_map):
	set_animation_up()
	var target_tile = Vector2(current_tile.x-1, current_tile.y)
	if object_map.walkable_tile(target_tile):
		moving = true
		target_location = current_location+game.DISTANCE_UP
	else:
		pick_random_direction()

func move_target_down(object_map):
	set_animation_down()
	var target_tile = Vector2(current_tile.x+1, current_tile.y)
	if object_map.walkable_tile(target_tile):
			moving = true
			target_location = current_location+game.DISTANCE_DOWN
	else:
		pick_random_direction()

# Handle damage
func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		death()

func heal(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health

func death():
	queue_free()

# Handle animations
func animate(delta):
	if moving:
		animation_timer += delta
	else:
		animation_timer = 0
		set_frame(0)
	if animation_timer > animation_cycle:
		var current_frame = get_frame()
		animation_timer = 0
		if current_frame == last_frame:
			set_frame(0)
		else:
			set_frame(current_frame+1)

# Directional flips and rotations
func set_animation_left():
	set_flip_h(true)
	set_rot(-PI/8)

func set_animation_right():
	set_flip_h(false)
	set_rot(PI/4+PI/8)

func set_animation_up():
	set_flip_h(true)
	set_rot(-PI/4-PI/8)

func set_animation_down():
	set_flip_h(false)
	set_rot(PI/8)