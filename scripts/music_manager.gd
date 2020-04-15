extends Node

var last_player : AudioStreamPlayer

var pass_min : float = 500.0
var pass_max : float = 8000.0

var filter_running = false

func play_music(music_clip):
	for player in $music.get_children():
		if player.is_playing() == true:
#			last_player.stream = music_clip
#			last_player.play() 
			break
		
		print(player.name)
		player.stream = music_clip
		player.play()
		last_player = player
		break
	pass


func apply_filter():
	$Tween.stop(AudioServer.get_bus_effect(1, 0), "cutoff_hz")
	
	AudioServer.set_bus_effect_enabled(1,0, true)
	AudioServer.get_bus_effect(1, 0).cutoff_hz =  pass_min
	filter_running = true
	pass

func disable_filter():
	$Tween.interpolate_property(AudioServer.get_bus_effect(1, 0), "cutoff_hz", pass_min, pass_max, 0.4, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	pass

func _on_Tween_tween_completed(object, key):
	AudioServer.set_bus_effect_enabled(1,0, false)
	filter_running = false
	pass 
