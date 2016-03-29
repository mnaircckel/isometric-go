extends CanvasLayer

var options = ["new","resume","options","quit"]
var option_index = 0
var menu_top = 186
var option_height = 62
var number_of_options = 4
var menu_bottom = menu_top + (number_of_options-1)*option_height
var select

func _ready():
	select = get_node("Select")
	set_process_input(true)

func _input(event):
	# Selection option
	if Input.is_action_pressed("ui_up") and !event.is_echo():
		option_index -= 1
		select.set_pos(select.get_pos()+Vector2(0,-option_height))
	if Input.is_action_pressed("ui_down") and !event.is_echo():
		option_index += 1
		select.set_pos(select.get_pos()+Vector2(0,option_height))
	
	if select.get_pos().y < menu_top:
		option_index = number_of_options-1
		select.set_pos(Vector2(select.get_pos().x,menu_bottom))
	elif select.get_pos().y > menu_bottom:
		option_index = 0
		select.set_pos(Vector2(select.get_pos().x,menu_top))
	
	# Chose option
	if Input.is_action_pressed("ui_accept") and !event.is_echo():
		execute_current_option()
		
func execute_current_option():
	if option_index == 0:
		var game_scene = preload("main.scn").instance()
		get_tree().get_root().add_child(game_scene)
		queue_free()
	elif option_index == 1:
		pass
	elif option_index == 2:
		pass
	elif option_index == 3:
		# Not sure if this is the correct way to quit
		queue_free()
		get_tree().quit()