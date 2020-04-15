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
	
	event_handler.connect("alert_guards", self, "on_alert_guards")
	
	if patrole_path != null:
		patrole_curve = get_node(patrole_path).get_curve()
	pass
	
func _process(delta):
	update()
	player_in_vision_cone()
	$CanvasLayer/exclamation_mark.rect_position = to_global($Position2D.position)
	pass
	
func on_alert_guards():
	alerted = true
	$draw_node.current_color = $draw_node.red
	$draw_node.current_boarder_color = $draw_node.boarder_red
	pass
	
func player_in_vision_cone():
	if player != null:
		var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self], $player_detection.collision_mask)
		if !ray.empty():
			if ray.collider.is_in_group("player"):
				if alerted == true && $behaviour_tree.current_state != $behaviour_tree.state_map["chase"]:
					$behaviour_tree.change_state("chase")
					$gui_animation.play("alarm_anim")
					pass
				elif sight_angle == 0.0:
					if player.position.angle_to_point(position) <= deg2rad(45) && player.position.angle_to_point(position) >= deg2rad(-45):
						if player.is_stealing == true && alerted == false:
							$behaviour_tree.change_state("chase")
							on_alert_guards()
							$gui_animation.play("alarm_anim")
				elif sight_angle == 180.0:
					if player.position.angle_to_point(position) <= deg2rad(180) && player.position.angle_to_point(position) >= deg2rad(135) || \
					   player.position.angle_to_point(position) <= deg2rad(-135) && player.position.angle_to_point(position) >= deg2rad(-180):
						if player.is_stealing == true && alerted == false:
							$behaviour_tree.change_state("chase")
							on_alert_guards()
							$gui_animation.play("alarm_anim")
				elif sight_angle == -90.0:
#					print(player.position.angle_to_point(position))
					if player.position.angle_to_point(position) <= deg2rad(-45) && player.position.angle_to_point(position) >= deg2rad(-135):
						if player.is_stealing == true && alerted == false:
							$behaviour_tree.change_state("chase")
							on_alert_guards()
							$gui_animation.play("alarm_anim")
				elif sight_angle == 90.0:
					if player.position.angle_to_point(position) <= deg2rad(135) && player.position.angle_to_point(position) >= deg2rad(45):
						if player.is_stealing == true && alerted == false:
							$behaviour_tree.change_state("chase")
							on_alert_guards()
							$gui_animation.play("alarm_anim")
	
#				elif player.position.angle_to_point(position) <= deg2rad(sight_angle + 45) && player.position.angle_to_point(position) >= deg2rad(sight_angle - 45):
#					if player.is_stealing == true && alerted == false:
##						print("guard stop that crimenal scum")
#						$behaviour_tree.change_state("chase")
#						alerted = true
#						$gui_animation.play("alarm_anim")
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
#	draw_circle(to_local(hit_point), 5.0, Color.blue)
#	draw_line(to_local(position), to_local(target), Color.red, 5.0, true)
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
		player = body
	pass

func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		player = null
	pass 

