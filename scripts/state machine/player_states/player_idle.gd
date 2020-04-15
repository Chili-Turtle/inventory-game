extends "res://scripts/state machine/state.gd"

func enter():
	owner.get_node("AnimationPlayer").stop()
	pass
	
func exit():
	pass
	
func update(_delta : float):
	owner.direction = Vector2()
	pass

func handle_input(_event):
	if _event.is_action_pressed("ui_right"):
		owner.get_node("state_machine").change_state("move")
	elif _event.is_action_pressed("ui_left"):
		owner.get_node("state_machine").change_state("move")
	elif _event.is_action_pressed("ui_up"):
		owner.get_node("state_machine").change_state("move")
	elif _event.is_action_pressed("ui_down"):
		owner.get_node("state_machine").change_state("move")
