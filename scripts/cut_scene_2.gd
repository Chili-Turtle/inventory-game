extends Node2D

var cut_scene_music = load("res://audio/music/confrontation.1.wav")

var index = 0
var can_interact = false

var dialogue_dic = { 0 : ["Boss", "You are back"], 
					 1 : ["Boss", "You just made the money back you stole, but you have to pay your fees, so you have to work for me a little bit longer, hahah!"],
					 2 : ["Boss", "Be grateful that I don't sell your sister and now, back to work!",]}

func _ready():
	event_handler.connect("dialogue_finished", self, "on_dialogue_finished")
	
	MM.play_music(cut_scene_music)
	pass
	
func load_dialogue():
	for key in dialogue_dic:
		event_handler.emit_signal("load_dialogue", dialogue_dic[key][1], dialogue_dic[key][0])
	pass
	
	
func on_dialogue_finished():
	$scene_animation.play("cut_scene_2")
	pass
	
func load_scene():
	pass

func _on_scene_animation_animation_finished(anim_name):
	if anim_name == "cut_scene_2":
		get_tree().change_scene("res://scenes/thanks_for_playing.tscn")
		pass
	pass
