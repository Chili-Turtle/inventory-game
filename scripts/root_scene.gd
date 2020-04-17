extends Node2D

var enable_presses : bool = false

var bar_music = load("res://audio/music/bar_music_1.wav")

var game_over_music = load("res://audio/music/game_over_1.wav")

func _on_root_scene_ready():
	event_handler.emit_signal("game_loaded")
	event_handler.emit_signal("load_dialogue", "Steal everything, be quiet and don't get seen" , "Instruction")
	event_handler.emit_signal("show_dialogue")
	event_handler.connect("player_died", self, "on_game_over")
	event_handler.connect("update_sprint", self, "on_update_sprint")
	
	$CanvasLayer/game_over/button_prompt.visible = false
	$CanvasLayer/game_over.visible = false
	
	MM.play_music(bar_music)
	
	pass
	
func _input(event):
	if event.is_action("interact"):
#		MM.play_music(clip)
#		$Camera2D.add_trauma(1.0)
		pass
		
	if event is InputEventKey:
		if event.scancode == KEY_R:
			get_tree().reload_current_scene()
		if event.scancode == KEY_T:
			get_tree().change_scene("res://scenes/GUI/Main_menu.tscn")
			pass
		pass

func on_game_over():
#	get_tree().paused = true
	$CanvasLayer/game_over.visible = true
	$CanvasLayer/game_over/button_prompt.visible = true
	Engine.time_scale = 0.5
	$CanvasLayer/game_over/AnimationPlayer.play("fade_in")
	MM.play_music(game_over_music)
	pass

func on_update_sprint(value):
	$CanvasLayer/player_sprint_bar.value = value
	pass
