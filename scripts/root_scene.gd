extends Node2D

var enable_presses : bool = false

var clip = load("res://audio/music/Brimstone.wav")

func _on_root_scene_ready():
	event_handler.emit_signal("game_loaded")
	event_handler.emit_signal("display_dialogue", "Steal everything, be quiet and don't get seen")
	event_handler.connect("player_died", self, "on_game_over")
	event_handler.connect("update_sprint", self, "on_update_sprint")
	
	$CanvasLayer/game_over/button_prompt.visible = false
	$CanvasLayer/game_over.visible = false
	
	MM.play_music(clip)
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	MM.play_music(clip)
	pass
	
func _input(event):
	if event.is_action("interact"):
		MM.play_music(clip)
#		$Camera2D.add_trauma(1.0)
		pass
		
	if enable_presses == true:
		if event is InputEventKey:
			if event.scancode == KEY_R:
				get_tree().reload_current_scene()
			if event.scancode == KEY_T:
				print("go to main menu")
		pass

func on_game_over():
#	get_tree().paused = true
	$CanvasLayer/game_over.visible = true
	Engine.time_scale = 0.5
	$CanvasLayer/game_over/AnimationPlayer.play("fade_in")
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	enable_presses = true
	$CanvasLayer/game_over/button_prompt.visible = true
	pass 
	
func on_update_sprint(value):
	$CanvasLayer/player_sprint_bar.value = value
	pass
