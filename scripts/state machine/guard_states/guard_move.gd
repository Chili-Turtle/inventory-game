extends "res://scripts/state machine/state.gd"

var speed : float = 40.0

func enter():
	print("%s entered" %name)
	pass
	
func exit():
	print("%s entered" %name)
	pass
	
func update(_delta : float):
	set_animation()
	
	owner.velocity = owner.direction * speed
	owner.velocity = owner.move_and_slide(owner.velocity)
	
	pass

func set_animation():
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= 45.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= -45.0:
		owner.get_node("AnimationPlayer").play("guard_right")
		owner.sight_angle = 0.0
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= 180.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= 135.0 or \
		rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= -135.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= -180.0:
		owner.get_node("AnimationPlayer").play("guard_left")
		owner.sight_angle = 180
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= 135.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= 45.0:
		owner.get_node("AnimationPlayer").play("guard_up")
		owner.sight_angle = -90
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= -45.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= -135.0:
		owner.get_node("AnimationPlayer").play("guard_down")
		owner.sight_angle = 90

func handle_input(_event):
	pass
