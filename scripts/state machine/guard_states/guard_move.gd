extends "res://scripts/state machine/state.gd"

var speed : float = 44.0

func enter():
	pass
	
func exit():
	pass
	
func update(_delta : float):
	set_animation()
	steering(_delta)
	
	owner.velocity = owner.direction
	owner.velocity += owner.steering * 1.5
	owner.velocity = owner.move_and_slide(owner.velocity.normalized() * speed)
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

func steering(_delta):
	if owner.get_rot_ray_cast() != null:
		if !owner.get_rot_ray_cast().empty():
			owner.steering = (owner.position - owner.get_rot_ray_cast().position).normalized() * 5.0
			owner.steering = Vector2().linear_interpolate(owner.steering, _delta * 15.0)
	else:
		owner.steering = owner.steering.linear_interpolate(Vector2(), _delta * 5.0)
