extends "res://scripts/state machine/state.gd"

func enter():
	owner.get_node("AnimationPlayer").stop()
	pass
	
func exit():
	pass
	
func update(_delta : float):
	pass

func handle_input(_event):
	pass
