extends Node

var last_player : AudioStreamPlayer
var replay_player : AudioStreamPlayer

var pass_min : float = 500.0
var pass_max : float = 8000.0

var filter_running = false

var current_clip

func play_music(music_clip):
	#check for same music clip
	if has_stream(music_clip) == true: #if true pause all player and resume the player with the same stream
		for player in $music.get_children():
			if player.stream_paused == false:
				player.set_stream_paused(true)
		
		replay_player.set_stream_paused(false)
		last_player = replay_player
		print("true")
	else:
		#if I dont't have a player with the same stream set the stream /if not last_player
		for player in  $music.get_children():
			if last_player != player:
				if last_player != null:
					last_player.set_stream_paused(true)
				
				last_player = player
				player.set_stream_paused(false)
				player.stream = music_clip
				player.play()
				break
	pass

func fade_out(player):
	$filter_tween.stop(player, "volumen_db")
	
	$filter_tween.interpolate_property(player, "volumen_db", 0, -90, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$filter_tween.start()
	pass

func has_stream(music_clip):
	for player in  $music.get_children():
		if player.stream == music_clip:
			replay_player = player
			return true
		else:
			continue
			
	return false
	pass


func apply_filter():
	$filter_tween.stop(AudioServer.get_bus_effect(1, 0), "cutoff_hz")
	
	AudioServer.set_bus_effect_enabled(1,0, true)
	AudioServer.get_bus_effect(1, 0).cutoff_hz =  pass_min
	filter_running = true
	pass

func disable_filter():
	$filter_tween.interpolate_property(AudioServer.get_bus_effect(1, 0), "cutoff_hz", pass_min, pass_max, 0.4, Tween.TRANS_EXPO, Tween.EASE_IN)
	$filter_tween.start()
	pass

func _on_Tween_tween_completed(object, key):
	AudioServer.set_bus_effect_enabled(1,0, false)
	filter_running = false
	pass 
