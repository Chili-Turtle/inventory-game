extends "res://scripts/state machine/state.gd"

var speed : float = 50.0

func enter():
	print("%s entered" %name)
	pass
	
func exit():
	print("%s entered" %name)
	pass
	
func update(_delta : float):
	owner.direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	owner.direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if Input.is_action_pressed("ui_right"):
		owner.get_node("AnimationPlayer").play("player_walk_right")
	elif Input.is_action_pressed("ui_left"):
		owner.get_node("AnimationPlayer").play("player_walk_left")
	elif Input.is_action_pressed("ui_up"):
		owner.get_node("AnimationPlayer").play("player_walk_up")
	elif Input.is_action_pressed("ui_down"):
		owner.get_node("AnimationPlayer").play("player_walk_down")
	else:
		owner.get_node("state_machine").change_state("idle")
	
	
	owner.direction = owner.direction.normalized() * speed
	pass

func handle_input(_event):
	if _event.is_action_pressed("ui_accept") && owner.can_sprint == true:
		owner.get_node("state_machine").change_state("dash")
	pass
