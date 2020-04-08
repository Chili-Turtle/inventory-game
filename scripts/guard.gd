extends KinematicBody2D

var hit_point : Vector2

var scent_path : Array = []

var target : Vector2 

var last_scent = null

var velocity : Vector2

var direction : Vector2

var speed : float = 50.0

func _ready():
	target = position
	pass
	
func _process(delta):
	update()
	detect_scent_trail()
	pass
	
func _physics_process(delta):
	
	if last_scent != null:
		direction = last_scent.position - position
		direction = direction.normalized()
		set_animation()
	else:
		direction = Vector2()
		
	velocity = direction * speed
	
	velocity = move_and_slide(velocity)
	pass
	
func player_in_vision():
#		if player != null:
#			if position.angle_to_point(player.position) <= deg2rad(45) && position.angle_to_point(player.position) >= -deg2rad(45):
#				var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self])
##				print(ray.collider.name)
#				if ray.collider.is_in_group("player"):
#					print("player in sight %s" %rad2deg(position.angle_to_point(player.position)))
#					if player.is_stealing == true:
#						print("Hey what are you doing")
#						player.cancel_stealing()
	pass

func set_animation():
	print(rad2deg(direction.angle_to(Vector2.RIGHT)))
	if rad2deg(direction.angle_to(Vector2.RIGHT)) <= 45.0 && rad2deg(direction.angle_to(Vector2.RIGHT)) >= -45.0:
		$AnimationPlayer.play("guard_right")
	if rad2deg(direction.angle_to(Vector2.RIGHT)) <= 180.0 && rad2deg(direction.angle_to(Vector2.RIGHT)) >= 135.0 or \
		rad2deg(direction.angle_to(Vector2.RIGHT)) <= -135.0 && rad2deg(direction.angle_to(Vector2.RIGHT)) >= -180.0:
		print(rad2deg(direction.angle_to(Vector2.RIGHT)))
		$AnimationPlayer.play("guard_left")
	if rad2deg(direction.angle_to(Vector2.RIGHT)) <= 135.0 && rad2deg(direction.angle_to(Vector2.RIGHT)) >= 45.0:
		print(rad2deg(direction.angle_to(Vector2.RIGHT)))
		$AnimationPlayer.play("guard_up")
	if rad2deg(direction.angle_to(Vector2.RIGHT)) <= -45.0 && rad2deg(direction.angle_to(Vector2.RIGHT)) >= -135.0:
		print(rad2deg(direction.angle_to(Vector2.RIGHT)))
		$AnimationPlayer.play("guard_down")
	
	
	pass
	
func detect_scent_trail():
	
	#save area in a array, get the last visible one
	
	#when visible, follow path
	
	if scent_path.size() <= 0:
#		target = position
		return
		pass
	#follow the area/scent which is nearest == follow path lagging behing
	
	#follow the area/scent which is furthest == could take shortcutes
	for scent in scent_path:
		if last_scent == null:
			last_scent = scent
			continue
	
	
		####---take the furthest---###
#		if last_scent.position.distance_to(position) < scent.position.distance_to(position):
#			last_scent = scent
#			target = scent.position
#		else: #delete the scent from the array if it isn't the furthest
#			scent_path.erase(scent)
		###------###
		target = last_scent.position
		
		###---nearest point---###
		if last_scent.position.distance_to(position) > scent.position.distance_to(position):
			last_scent = scent
			target = scent.position

		if last_scent.position.distance_to(position) <= 2.0:
			scent_path.erase(scent)
			last_scent = null
			pass
		###------###
	#vision field = if player is in vision 180° and he pick pockets, go after him
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
	pass

func _on_detect_radius_area_entered(area):
	if area.is_in_group("scent"):
#		print("I sniffel a rat")
		if get_ray_cast(area.position).collider.is_in_group("scent"):
			#just save those in the array
#			print("I see a rat")
			scent_path.append(area)
			print(scent_path[0].position)
	pass


func _on_detect_radius_area_exited(area):
#	print("area has exited")
	scent_path.erase(area)
	if last_scent == area:
		last_scent = null
	pass 
