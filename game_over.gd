extends CanvasLayer

var game

func _ready():
	set_process_input(true)
	game = get_tree().get_root().get_node("Game")

func _input(event):
	# Quit
	if Input.is_action_pressed("ui_exit") and !event.is_echo():
		game.quit_to_main_menu()
		queue_free()
