extends Control

var game_over_screen = load("res://audio/music/Terrible Fate (fade).wav")

func _ready():
	MM.play_music(game_over_screen)
	pass

func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/GUI/Main_menu.tscn")
	pass
