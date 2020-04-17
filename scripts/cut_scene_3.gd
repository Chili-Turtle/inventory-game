extends Node2D

var cut_scene_music = load("res://audio/music/confrontation.1.wav")

var index = 0
var can_interact = false

var dialogue_dic = { 0 : ["Boss", "Am I a joke to you?"], 
					 1 : ["Boss", "Did you think you could beg, and I give your sister back"],
					 2 : ["Boss", "I already sold her, she is gone, haha!",],
					 3 : ["Boss", "Now be gone scum",]}

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
