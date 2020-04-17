extends Node2D

var current_color : Color
var current_boarder_color : Color

var orange : Color = Color(0.6, 0.2, 0.0, 0.5)
var red : Color = Color(0.8, 0.0, 0.0, 0.3)
var boarder_red : Color = Color(1.0, 0.0, 0.0, 0.5)

export(float) var radius : float = 60.0
export(bool) var draw_circle : bool = true


func _ready():
	current_color = orange
	current_boarder_color =  Color.orange
	update()
	pass

func _draw():
	
	if owner.alerted == true:
		draw_circle_arc_poly(position, radius, 0, 360, red)
	else:
		draw_arc(position, 60.0, deg2rad(owner.sight_angle+45), deg2rad(owner.sight_angle-45), 10, current_boarder_color, 2.0, true)
		draw_circle_arc_poly(position, radius, owner.sight_angle +45, owner.sight_angle -45, current_color)
	
	pass

func _process(delta):
	update()

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array() # PackedVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color]) # PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
