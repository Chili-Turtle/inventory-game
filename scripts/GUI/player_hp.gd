extends ProgressBar

func _ready():
	event_handler.connect("update_player_hp", self , "on_update_player_hp")
	
func on_update_player_hp(health):
	value = health
	pass
