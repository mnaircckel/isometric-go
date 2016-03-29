extends CanvasLayer

var game
var player

func _ready():
	set_process(true)
	game = get_parent()
	player = game.get_node("Player")

func _process(delta):
	update_hud()

func update_hud():
	get_node("Time").set_text(str(int(game.get_time_left())))
	get_node("Lives").set_text("x"+str(player.current_health))
	


