extends Node2D

var pocket_color : Color = Color(0.2, 0.6, 0.0, 0.5)
var transparent_color : Color = Color(0.0, 0.0, 0.0, 0.0)
var current_color : Color

func _ready():
	current_color = transparent_color
	pass

func _draw():
	if owner.player != null:
		draw_circle(position, owner.player.pocketing_range, current_color)
		

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
