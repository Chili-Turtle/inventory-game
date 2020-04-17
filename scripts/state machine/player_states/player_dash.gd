extends "res://scripts/state machine/state.gd"

var speed : float = 180.0

func enter():
	$dash_timer.start()
	owner.sprint_value = 0.0
	owner.can_sprint = false
	$dust_particles.get_process_material().direction = -Vector3(owner.direction.normalized().x, owner.direction.normalized().y, 0.0)
	$dust_particles.position = owner.position
	$dust_particles.restart()
	$dust_particles.emitting = true
	pass
	
func exit():
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
	pass


func _on_dash_timer_timeout():
	owner.get_node("state_machine").change_state("move")
	pass
