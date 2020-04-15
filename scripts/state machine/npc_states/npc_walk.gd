extends "res://scripts/state machine/state.gd"

var speed = 20.0

func enter():
	pass
	
func exit():
	pass
	
func update(_delta : float):
	patrol(_delta)
	set_animation()
	
	print(owner.name)
	
	owner.velocity += owner.steering
	owner.velocity = owner.velocity.normalized() * speed
	owner.velocity = owner.move_and_slide(owner.velocity)
	pass

func handle_input(_event):
	pass
	
func patrol(_delta):
	print(owner.patrole_path)
	if owner.patrole_path == null:
		return
	
	owner.direction = owner.patrole_curve.get_point_position(owner.index) - owner.position

	if owner.patrole_curve.get_point_position(owner.index).distance_to(owner.position) <= 2.0:
		owner.index += 1
		owner.index = owner.index % owner.patrole_curve.get_point_count()

	owner.velocity = owner.direction.normalized()
	
	if owner.get_ray_cast() != null:
		if !owner.get_ray_cast().empty():
			owner.steering = (owner.position - owner.get_ray_cast().position).normalized() * 5.0
			owner.steering = Vector2().linear_interpolate(owner.steering, _delta * 15.0)
	else:
		owner.steering = owner.steering.linear_interpolate(Vector2(), _delta * 5.0)

func set_animation():
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= 45.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= -45.0:
		owner.get_node("AnimationPlayer").play("npc_right")
		owner.sight_angle = 0.0
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= 180.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= 135.0 or \
		rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= -135.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= -180.0:
		owner.get_node("AnimationPlayer").play("npc_left")
		owner.sight_angle = 180 #this sould be also -180
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= 135.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= 45.0:
		owner.get_node("AnimationPlayer").play("npc_up")
		owner.sight_angle = -90
	if rad2deg(owner.direction.angle_to(Vector2.RIGHT)) <= -45.0 && rad2deg(owner.direction.angle_to(Vector2.RIGHT)) >= -135.0:
		owner.get_node("AnimationPlayer").play("npc_down")
		owner.sight_angle = 90
