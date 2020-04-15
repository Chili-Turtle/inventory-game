extends Node2D

var pocket_color : Color = Color(0.2, 0.6, 0.0, 0.5)
var transparent_color : Color = Color(0.0, 0.0, 0.0, 0.0)
var current_color : Color

var orange : Color = Color(0.6, 0.2, 0.0, 0.5)

export(float) var radius : float = 20.0
export(bool) var draw_circle : bool = true


func _ready():
	current_color = transparent_color
	update()
	pass

func _draw():
	if owner.player != null && draw_circle == true:
		draw_circle(position, owner.player.pocketing_range, current_color)
	
	draw_circle_arc_poly(position, radius, owner.sight_angle +45, owner.sight_angle -45, orange)
#	draw_colored_polygon(pool, Color.red)

#	var resolution = 8
#	var pointArray = PoolVector2Array()
#	var step = deg2rad(180)/resolution #or 2*PI (D=2*PI)
#	var theta = 0
#	while theta <= deg2rad(180): #or 2*PI (D=2*PI)
#		print(theta)
#		var points = Vector2(cos(theta),-sin(theta)) * 30.0 #radius
##		draw_circle(points, 10.0,Color(1,0,0,1))
#		pointArray.append(points.rotated(PI/2))
##		pointArray.append(points)
#		theta += step
#
#	for s in range(pointArray.size() -1):
#		draw_line(pointArray[s],pointArray[s+1],Color(0,1,0,1),0.05,true)
#		draw_colored_polygon(pointArray, Color(1,0,0,0.5))
	pass

func _process(delta):
	update()
	if owner.player != null:
		current_color = current_color.linear_interpolate(pocket_color, delta * 10.0)
	else:
		current_color = current_color.linear_interpolate(transparent_color, delta * 10.0)


func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array() # PackedVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color]) # PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
