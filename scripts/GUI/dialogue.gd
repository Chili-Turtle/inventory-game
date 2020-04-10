extends Control

onready var label = $MarginContainer/RichTextLabel

var dialogue : String

var is_on_screen : bool = false

func _ready():
	event_handler.connect("display_dialogue", self, "start_dialogue")
	pass
	
func start_dialogue(_dialogue : String):
	label.visible_characters = 0
	dialogue = _dialogue
	label.text = dialogue
	
	if is_on_screen == false:
		$AnimationPlayer.play("move_in")
	else:
		$text_speed.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "move_in":
		$text_speed.start()
		is_on_screen = true
#		on_display_dialogue()
	
#func on_display_dialogue():
#	$text_speed.start()
#	label.text = dialogue
#	pass
	
func _input(event):
	if Input.is_action_just_pressed("interact"):
		end_dialogue()
	pass

func end_dialogue():
	if label.visible_characters >= dialogue.length() and dialogue != "":
		dialogue = ""
		$AnimationPlayer.play("move_out")
		is_on_screen = false
	else:
		label.visible_characters = dialogue.length()
		
	$MarginContainer/RichTextLabel/end_dialogue.visible = true
	
	pass

func _on_text_speed_timeout():
	label.visible_characters += 1
	
	if label.visible_characters >= dialogue.length():
		$text_speed.stop()
		$MarginContainer/RichTextLabel/end_dialogue.visible = true
	pass
