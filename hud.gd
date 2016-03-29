extends CanvasLayer

var game

func _ready():
	set_process(true)
	game = get_parent()

func _process(delta):
	update_time()

func update_time():
	get_node("Time").set_text(str(int(game.get_time_left())))
	


