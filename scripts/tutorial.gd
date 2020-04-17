extends Node2D

func _ready():
	event_handler.connect("player_died", self, "on_player_death")
	pass
	
func on_player_death():
	get_tree().change_scene("res://scenes/GUI/Main_menu.tscn")
	pass
