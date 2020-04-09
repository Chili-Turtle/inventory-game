extends "res://scripts/state machine/state.gd"

func enter():
	print("%s entered" %name)
	owner.get_node("AnimationPlayer").stop()
	pass
	
func exit():
	print("%s entered" %name)
	pass
	
func update(_delta : float):
	pass

func handle_input(_event):
	pass
