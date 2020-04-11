extends Node

var last_player : AudioStreamPlayer

func play_music(music_clip):
	for player in $music.get_children():
		if player.is_playing() == true:
			last_player.stream = music_clip
			last_player.play() 
			print(player)
			continue
		
		print(player.name)
		player.stream = music_clip
		player.play()
		last_player = player
		break
	pass
