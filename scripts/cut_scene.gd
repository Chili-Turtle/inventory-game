extends Node2D

var cut_scene_music = load("res://audio/music/confrontation.1.wav")

var index = 0
var can_interact = false

var dialogue_dic = { 0 : ["Boss", "Did you think you could steal from me?"], 
					 1 : ["Boss", "Every action has its price, so I guess I keep your sister, until you payed me back"],
					 2 : ["Boss", "Now go and make my money back",],
					 3 : ["Boss", "And don't forget if you don't make enough money I sell you sister"]}

func _ready():
	event_handler.connect("dialogue_finished", self, "on_dialogue_finished")
	
	MM.play_music(cut_scene_music)
	pass
	
func load_dialogue():
	event_handler.emit_signal("load_dialogue", dialogue_dic[0][1], dialogue_dic[0][0])
	event_handler.emit_signal("load_dialogue", dialogue_dic[1][1], dialogue_dic[1][0])
	event_handler.emit_signal("load_dialogue", dialogue_dic[2][1], dialogue_dic[2][0])
	event_handler.emit_signal("load_dialogue", dialogue_dic[3][1], dialogue_dic[3][0])
	pass
	
	
func on_dialogue_finished():
	$scene_animation.play("cut_scene_2")
	pass
	
func load_scene():
	pass

func _on_scene_animation_animation_finished(anim_name):
	if anim_name == "cut_scene_2":
		get_tree().change_scene("res://scenes/root scene.tscn")
		pass
	pass
