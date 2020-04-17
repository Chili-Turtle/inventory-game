extends "res://scripts/state machine/state.gd"

var bar_music = load("res://audio/music/bar_music_1.wav")

func enter():
	owner.get_node("state_machine").change_state("move")
	
	MM.play_music(bar_music)
	pass
	
func exit():
	pass
	
func update(_delta : float):
	patrol(_delta)
	pass

func handle_input(_event):
	pass

func patrol(_delta):
	if owner.patrole_path == null:
		return
	
	owner.direction = owner.patrole_curve.get_point_position(owner.index) - owner.position

	if owner.patrole_curve.get_point_position(owner.index).distance_to(owner.position) <= 2.0:
		owner.index += 1
		owner.index = owner.index % owner.patrole_curve.get_point_count()
#		owner.get_node("state_machine").change_state("idle") #use look around instead/used for a breakes

	owner.direction = owner.direction.normalized()
	
#	if owner.get_ray_cast() != null:
#		if !owner.get_ray_cast().empty():
#			owner.steering = (owner.position - owner.get_ray_cast().position).normalized() * 5.0
#			owner.steering = Vector2().linear_interpolate(owner.steering, _delta * 15.0)
#	else:
#		owner.steering = owner.steering.linear_interpolate(Vector2(), _delta * 5.0)
