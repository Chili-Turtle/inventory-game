extends KinematicBody2D

var hit_point : Vector2

var scent_path : Array = []

var target : Vector2 

var last_scent = null

var velocity : Vector2

var direction : Vector2

var sight_angle = 0.0

var player = null

var index = 0

var alerted : bool = false

export(NodePath) var patrole_path = null

var patrole_curve : Curve2D

func _ready():
	target = position
	
	if patrole_path != null:
		patrole_curve = get_node(patrole_path).get_curve()
	pass
	
func _process(delta):
	update()
	player_in_vision_cone()
	pass
	
func _physics_process(delta):
	#stand_still state
	#if no scent is there stop, and turn/player left, right.. animation, and ajust the angle
	pass
	
#	player.position.angle_to_point(position)
	
func player_in_vision_cone():
	if player != null:
		var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self])
		if !ray.empty():
			if ray.collider.is_in_group("player"):
				if alerted == true:
					$behaviour_tree.change_state("chase")
#					print("player in sight %s" %rad2deg(position.angle_to_point(player.position)))
				elif player.position.angle_to_point(position) <= deg2rad(sight_angle + 45) && player.position.angle_to_point(position) >= deg2rad(sight_angle - 45):
					if player.is_stealing == true:
#						print("guard stop that crimenal scum")
						$behaviour_tree.change_state("chase")
						alerted = true
	pass

func get_ray_cast(target : Vector2):
	Physics2DServer.ray_shape_create()
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target, [self], collision_mask, true, true)
	
	if result.empty():
		return
	
	#debugging
	hit_point = result.position
	
	return result
	
func _draw():
	draw_circle(to_local(hit_point), 5.0, Color.blue)
	draw_line(to_local(position), to_local(target), Color.red, 5.0, true)
	
	draw_arc(to_local(position), 60.0, deg2rad(sight_angle+45), deg2rad(sight_angle-45), 10,Color.orange, 3.0, true)
	pass

func _on_detect_radius_area_entered(area):
	if area.is_in_group("scent"):
#		print("I sniffel a rat")
		if get_ray_cast(area.position).collider.is_in_group("scent"):
			#just save those in the array
#			print("I see a rat")
			scent_path.append(area)
	pass

func _on_detect_radius_area_exited(area):
#	print("area has exited")
	scent_path.erase(area)
	if last_scent == area:
		last_scent = null
	pass 

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		print(player)
		player = body
	pass

func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		player = null
		print("player deleted")
	pass 

