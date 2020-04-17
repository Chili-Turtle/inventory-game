extends Control

onready var label = $MarginContainer/RichTextLabel

var dialogue : String

var dialogue_list : Array = []
var name_list : Array = []

var is_running : bool = false
var on_screen : bool = false

func _ready():
	event_handler.connect("load_dialogue", self, "on_load_dialogue")
	event_handler.connect("show_dialogue", self, "on_show_dialogue")
	visible = true
	pass
	
func on_load_dialogue(_dialogue : String, _name):
	dialogue_list.append(_dialogue)
	name_list.append(_name)
	
	if is_running == false:
		on_show_dialogue()
		pass
	pass
	
func on_show_dialogue(): #show dialogue
	if !dialogue_list.empty():
		label.visible_characters = 0
		$Panel/name_panel/name.text = name_list.front()
		label.text = dialogue_list.front()
		is_running = true
		$AnimationPlayer.play("move_in")
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "move_in":
		$text_speed.start()
		on_screen = true
		pass

func _input(event):
	if Input.is_action_just_pressed("interact"):
			
		if !dialogue_list.empty():
			if label.visible_characters <= dialogue_list.front().length() && is_running == true:
				label.visible_characters = dialogue_list.front().length()
			else:
				on_show_dialogue()
		else:
			end_dialogue()
	pass

func end_dialogue():
	if on_screen == true:
		$AnimationPlayer.play("move_out")
		event_handler.emit_signal("dialogue_finished")
		on_screen = false
	pass

func _on_text_speed_timeout():
	label.visible_characters += 1

	if label.visible_characters >= dialogue_list.front().length():
		$text_speed.stop()
		$MarginContainer/RichTextLabel/end_dialogue.visible = true
		is_running = false
		
		name_list.pop_front()
		dialogue_list.pop_front()
	pass
