extends Node2D

func _on_root_scene_ready():
	event_handler.emit_signal("game_loaded")
	pass
