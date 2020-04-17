extends Area2D

export(String) var dialogue : String

var is_triggerd = false

func _on_dialogue_trigger_body_entered(body):
	if body.is_in_group("player") && is_triggerd == false:
		event_handler.emit_signal("load_dialogue", dialogue, "Instruction")
		is_triggerd = true
		pass 
