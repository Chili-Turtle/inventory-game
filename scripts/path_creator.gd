extends Line2D

var is_started : bool = false
var is_checked : bool = false
var is_ended : bool = false

func _ready():
	clear_points()
	pass

func create_collision():
	###---create start_trigger---###
	var start_trigger = Area2D.new()
	add_child(start_trigger)
	start_trigger.position = points[0]
	start_trigger.name = "start_trigger"
	start_trigger.connect("area_exited",self, "on_pocketing_started")
	var start_collision = CollisionShape2D.new()
	start_trigger.add_child(start_collision)
	start_collision.shape = RectangleShape2D.new() 
	start_collision.shape.extents.x = width / 2.0
	start_collision.shape.extents.y = 4.0
	
	###---create middle_trigger---###
	var middle_trigger = Area2D.new()
	add_child(middle_trigger)
	middle_trigger.position = points[points.size()/2]
	###---calc rotation of trigger---###
	var rot_dir_1 = points[(points.size()/2) -1] - points[(points.size()/2)]
	var rot_dir_2 = points[(points.size()/2) +1] - points[(points.size()/2)]
	var rot_dir_angle = rot_dir_1.angle_to(rot_dir_2) / 2.0
#	print("rot_dir_angle %s" %rad2deg(rot_dir_angle))
	var rot_dir_3 = rot_dir_1.rotated(rot_dir_angle)
	
#	###----calc trigger lenght---###
#	var rest_angle = 90-rad2deg(abs(rot_dir_angle))
#	print("rest_angle %s" %rest_angle)
#	var trigger_l = (width/2.0) / sin(deg2rad(rest_angle))
#	print("trigger_l %s" %trigger_l)
	
	middle_trigger.name = "middle_trigger"
	middle_trigger.connect("area_entered",self, "on_pocketing_checkpoint")
	var middle_collision = CollisionShape2D.new()
	middle_trigger.add_child(middle_collision)
	middle_collision.shape = RectangleShape2D.new() 
	middle_trigger.rotation = rot_dir_3.angle() #rotation to x vector
	middle_collision.shape.extents.x = width / 1.5
	middle_collision.shape.extents.y = 4.0
	
	###---create end_trigger---###
	var end_trigger = Area2D.new()
	add_child(end_trigger)
	end_trigger.position = points[points.size()-1]
	end_trigger.name = "end_trigger"
	end_trigger.connect("area_entered",self, "on_pocketing_ended")
	var end_collision = CollisionShape2D.new()
	end_trigger.add_child(end_collision)
	end_collision.shape = RectangleShape2D.new() 
	end_collision.shape.extents.x = 4.0
	end_collision.shape.extents.y = width / 2.0
	
	###---calc the boundary points---###
	var deg_90 = 90.0
	for u in range(0,2):
		if u >= 1:
			deg_90 = deg_90 * -1
		###---calculate points---###
		var direction = []
		var dir_rot_90 = []
		var trans_point = []
		for i in range(0, get_point_count()):
			#---beginn cap---#
			if i == 0:
				#get direction
				direction.append((points[i] - points[i + 1]).normalized())
				#rotate direction 90 deg
				dir_rot_90.append(direction[i].rotated(deg2rad(deg_90)))
				#draw first point
				trans_point.append(points[i] + dir_rot_90[i] * (width * 0.5))
				continue
			#---end cap---#
			if i == get_point_count() - 1:
				#calc the rotated direction
				trans_point.append(points[i] + dir_rot_90[i-1] * (width * 0.5))
				continue
			#---points in the middle---#
			#get direction
			direction.append((points[i] - points[i + 1]).normalized())
			#rotate direction 90 deg
			dir_rot_90.append(direction[i].rotated(deg2rad(deg_90)))
			#get the theta angle
			var angle_theta_rad = (dir_rot_90[i-1].angle_to(dir_rot_90[i])) * 0.5
			#calc the vector theta
			var dir_rot_theta = dir_rot_90[i-1].rotated(angle_theta_rad)
			#calc the alpha angle for the length
			var angle_alpha_deg = 90 - rad2deg(angle_theta_rad)
			#calc the length of the triangle
			var length = (width * 0.5) / sin(deg2rad(angle_alpha_deg))
			#draw point
			trans_point.append(points[i] + dir_rot_theta * length)
	
		###---assign collision to points---###
		for i in range(0, get_point_count()-1):
			####---create area2D---###
			var boundary = Area2D.new()
			add_child(boundary)
			boundary.name = "boundary" + str(i)
#			boundary.connect("area_entered",self, "on_bumped_in")
			boundary.connect("area_entered",get_parent(), "on_bumped_in")
			
			###---buildthe collision_shape---###
			var collision_boundary = CollisionShape2D.new()
			boundary.add_child(collision_boundary)
			
			
			###---shape---###
			collision_boundary.shape = SegmentShape2D.new()
			
			collision_boundary.shape.a = trans_point[i]
			collision_boundary.shape.b = trans_point[i + 1]
		pass
	pass
	
func on_bumped_in(area):
	if area.is_in_group("item"):
#		print("ALARM ALARM, someone steals from me")
		pass
	pass
	
func on_pocketing_started(area): #on_pocketing_checkpoint
	if area.is_in_group("item"):
		#restart start if you put down item
		
		#start timer of npc
		
		is_started = !is_started
		if is_started == true:
#			print("pocketing started")
			event_handler.emit_signal("pocketing_started")
			#start timer when on path
		elif is_started == false:
			event_handler.emit_signal("pocketing_canceled")
			is_checked = false
			is_started = false
			pass
#			print("pocketing ended")
			#maybe stop the timer
#			event_handler.emit_signal("pocketing_canceled")
	pass

func on_pocketing_checkpoint(area):
	if area.is_in_group("item"):
		if is_started == true:
			is_checked = true
#			print("checkpoint reached")
		elif is_started == false:
#			print("you have to go to start first")
			pass
	
func on_pocketing_ended(area):
	if area.is_in_group("item"):
		if is_started == true && is_checked == true:
#			print("you did it")
			event_handler.emit_signal("pocketing_ended")
			is_checked = false
			is_started = false
		elif is_started == true && is_checked == false:
			print("you cheated buuuh")
			#cancel stealing attempt
		elif is_started == false:
#			print("you have to go trough the path")
			pass
	
func clear_path():
	
#	if $boundary == null:
#		return
	
	#clear the boudary and the path/points, I already have the area2d
	
	#clear the boudary and the path/points, area2d
	for child in get_children():
		child.call_deferred("queue_free")
		pass
#	$boundary.call_deferred("queue_free")
	clear_points()
	
	#clear Line2D
	
	pass
	
func _draw():
	if points.empty() == true:
		return
	#og line2D poitns
	var last_point : Vector2 = points[0]
	var dir = last_point - points[1]
	for i in range(1, get_point_count()):
		draw_line(points[i-1], points[i], Color.red, 5.0, false)
	
	#create boundary points
	var deg_90 = 90.0
	for u in range(0,2):
		if u >= 1:
			deg_90 = deg_90 * -1

		var direction = []
		var dir_rot_90 = []
		var trans_point = []
		for i in range(0, get_point_count()):
			#beginn cap
			if i == 0:
				#get direction
				direction.append((points[i] - points[i + 1]).normalized())
				#rotate direction 90 deg
				dir_rot_90.append(direction[i].rotated(deg2rad(deg_90)))
				#draw first point
				trans_point.append(points[i] + dir_rot_90[i] * (width * 0.5))
				draw_circle(trans_point[i], 5.0, Color.blue)
				continue
			#end cap
			if i == get_point_count() - 1:
				#calc the rotated direction
				trans_point.append(points[i] + dir_rot_90[i-1] * (width * 0.5)) #30.0 is the width of the path
				draw_circle(trans_point[i], 5.0, Color.blue)
				continue
			#get direction
			direction.append((points[i] - points[i + 1]).normalized())
			#rotate direction 90 deg
			dir_rot_90.append(direction[i].rotated(deg2rad(deg_90)))
			#get the theta angle
			var angle_theta_rad = (dir_rot_90[i-1].angle_to(dir_rot_90[i])) * 0.5
			#calc the vector theta
			var dir_rot_theta = dir_rot_90[i-1].rotated(angle_theta_rad)
			#calc the alpha angle for the length
			var angle_alpha_deg = 90 - rad2deg(angle_theta_rad)
			#calc the length of the triangle
			var length = (width * 0.5) / sin(deg2rad(angle_alpha_deg))
			#draw point
			trans_point.append(points[i] + dir_rot_theta * length)
			draw_circle(trans_point[i], 5.0, Color.blue)
