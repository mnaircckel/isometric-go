extends Sprite

# Player variables
var game
# Animation constants
const last_frame = 4
const animation_cycle = .15
# Animation variables
var animation_timer = 0
var current_frame = 0
# Movement
var moving = false
var movement_timer = 0
var current_tile = Vector2(0,0)
var current_location
var target_location
# Firing
var firing = false
var bomb_delay = 1.5
var firing_timer = 0
var bomb_strength = 2
# Health
var current_health = 4
var max_health = 4

# When player is loaded into scene
func _ready():
	set_process(true)
	game = get_parent()
	current_location = get_pos()
	target_location = get_pos()

# Process every frame
func _process(delta):
	handle_input()
	animate(delta)
	move(delta)
	place_bombs(delta)

# All input is handled here
func handle_input():
	# Directional input will attempt to update target location
	if !moving:
		movement_timer = 0
		var object_map = game.get_node("ObjectMapHandler")
		if Input.is_action_pressed("ui_left"):
			move_target_left(object_map)
		elif Input.is_action_pressed("ui_right"):
			move_target_right(object_map)
		elif Input.is_action_pressed("ui_up"):
			move_target_up(object_map)
		elif Input.is_action_pressed("ui_down"):
			move_target_down(object_map)
	
	# Queue firing by setting firing to true
	if !firing and firing_timer == 0:
		if Input.is_action_pressed("ui_space"):
			firing = true

# Handle movement based on target_location
func move(delta):
	var to_move = target_location-current_location
	if reached_target_location():
		moving = false
		if to_move == game.DISTANCE_LEFT:
			current_tile.y += 1
		elif to_move == game.DISTANCE_RIGHT:
			current_tile.y -= 1
		elif to_move == game.DISTANCE_UP:
			current_tile.x -= 1
		elif to_move == game.DISTANCE_DOWN:
			current_tile.x += 1
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
	
func move_target_right(object_map):
	set_animation_right()
	var target_tile = Vector2(current_tile.x, current_tile.y-1)
	if object_map.walkable_tile(target_tile):
		moving = true
		target_location = current_location+game.DISTANCE_RIGHT

func move_target_up(object_map):
	set_animation_up()
	var target_tile = Vector2(current_tile.x-1, current_tile.y)
	if object_map.walkable_tile(target_tile):
		moving = true
		target_location = current_location+game.DISTANCE_UP

func move_target_down(object_map):
	set_animation_down()
	var target_tile = Vector2(current_tile.x+1, current_tile.y)
	if object_map.walkable_tile(target_tile):
			moving = true
			target_location = current_location+game.DISTANCE_DOWN

# Handle bomb placement
func place_bombs(delta):
	firing_timer -= delta
	if firing_timer < 0:
		firing_timer =  0
	if firing and !moving:
		var object_map = game.get_node("ObjectMapHandler")
		firing_timer = bomb_delay
		firing = false
		if object_map.walkable_tile(current_tile):
			object_map.place_bomb(current_tile, bomb_strength)

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
	game.game_over()

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