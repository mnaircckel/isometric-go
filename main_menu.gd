extends CanvasLayer

# Menu constants
const options = ["new","resume","options","quit"]
const menu_top = 186
const option_height = 62
const number_of_options = 4
const GameScene = preload("main.scn")
# Menu variables
var option_index = 0
var select
var active_game
var clear_game

func _ready():
	select = get_node("Select")
	set_process_input(true)
	if active_game == false:
		free_current_game()
	update_select_to_option()

func _input(event):
	# Selection option
	if Input.is_action_pressed("ui_up") and !event.is_echo():
		option_index -= 1
	if Input.is_action_pressed("ui_down") and !event.is_echo():
		option_index += 1
	
	if option_index < 0:
		option_index = number_of_options-1
	elif option_index > number_of_options-1:
		option_index = 0
	
	update_select_to_option()
	
	# Chose option
	if Input.is_action_pressed("ui_accept") and !event.is_echo():
		execute_current_option()

func update_select_to_option():
	select.set_pos(Vector2(select.get_pos().x,menu_top + option_height*option_index))
		
func execute_current_option():
	if option_index == 0:
		start_game()
	elif option_index == 1:
		resume()
	elif option_index == 2:
		pass
	elif option_index == 3:
		# Not sure if this is the correct way to quit
		queue_free()
		get_tree().quit()

func free_current_game():
	get_tree().get_root().remove_child(get_tree().get_root().get_node("Game"))

func start_game():
	var game_scene = GameScene.instance()
	if active_game:
		free_current_game()
	get_tree().get_root().add_child(game_scene)
	get_tree().set_pause(false)
	queue_free()

func resume():
	if active_game:
		get_tree().set_pause(false)
		queue_free()