extends Node2D

func _on_root_scene_ready():
	event_handler.emit_signal("game_loaded")
	
	event_handler.emit_signal("display_dialogue", "Steal everything, be quiet and don't get seen")
	
	pass
	
func _input(event):
	if event.is_action("interact"):
#		$Camera2D.add_trauma(1.0)
		pass
