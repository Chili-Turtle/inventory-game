extends KinematicBody2D

export var ray_length : float = 30.0

var inventory : Dictionary = {}

var current_inventory_space = 0
var max_inventory_space = 9

var velocity : Vector2

var direction : Vector2

#var speed : float = 0.0 #20

var notice_value = 0

var index = 0

var sight_angle = 0.0

var angle = 0

var pocket_color : Color = Color(0.2, 0.6, 0.0, 0.3)
var transparent_color : Color = Color(0.0, 0.0, 0.0, 0.0)
var current_color : Color

var player = null

var hit_point = Vector2()

var steering : Vector2 = Vector2()

export(NodePath) var patrole_path = null

var patrole_curve : Curve2D

func _ready():
	current_color = transparent_color
#	print("this is the path: %s " %to_global($Path2D.get_curve().get_point_position(0)))
#	print("this is the path: %s " %get_node(patrole_path).get_curve().get_point_position(0))
	if patrole_path != null:
		patrole_curve = get_node(patrole_path).get_curve()
	
#	print($Path2D.curve.get_point_position(0) - position)
	
#	print(global_position)
	event_handler.connect("game_loaded", self, "on_game_loaded")
	
	init_inventory()
	
	add_item("sword")
	add_item("axe")
#	print(inventory)

	pass

func on_pick_pocket_noticed():
#	print("stop stealing from me")
	pass

func init_inventory():
	for i in range(0, max_inventory_space + 1):
		inventory[i] = null
	pass

func on_game_loaded():
	pass
	
func add_item(item_name):
	for key in inventory:
		if inventory[key] == null:
			inventory[key] = item_name
			return
		
	print("inventory is full")
	pass
	
func remove_item(item_name):
	var arr : Array = []
	
	for key in inventory:
		if inventory[key] == item_name:
			inventory.erase(key)
			current_inventory_space -= 1
	pass

func _process(delta):
	
	if player != null:
		current_color = current_color.linear_interpolate(pocket_color, delta * 10.0)
	else:
		current_color = current_color.linear_interpolate(transparent_color, delta * 10.0)
	
	angle -= delta * 500.0
	update()
	is_player_in_vision()
	pass
	
func add_notice(value : float):
	notice_value += value
	pass
	
func is_player_in_vision(): #this should be a bool
	if player == null:
		return
	
	#if left and between 45, -45
	#if right and between 135 and -135
	#if down and between -45, -135
	#if up and between 45, 135
	
	 #0.0 when right 180 when left, when npc is left == 0.0, when npc is right 180
	if player.position.angle_to_point(position) <= deg2rad(sight_angle + 45) && player.position.angle_to_point(position) >= deg2rad(sight_angle - 45):
		var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self])
#		print("in vision cone")
		if !ray.empty():
			if ray.collider.is_in_group("player"):
				if player.is_stealing == true:
					player.cancel_stealing()
					print("Hey what are you doing")
				#add suspicion level if you have more then 2-3 all guard are immediately alerted
	pass

func get_ray_cast():
	Physics2DServer.ray_shape_create()
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, position + (Vector2.UP * 30.0).rotated(deg2rad(angle)), [self], collision_mask)
	
	if result.empty():
		return
	
	hit_point = result.position
	
	return result
	pass

func _draw():
#	draw_circle(to_local(hit_point), 5.0, Color.blue)
#	draw_circle(to_local(global_position), 5.0, Color.blue)
#	draw_line(to_local(position), (to_local(position) + Vector2.UP * ray_length).rotated(deg2rad(angle)), Color.red, 3.0, true)
#	draw_line(to_local(position), (to_local(position) + velocity), Color.green, 3.0, true)
	
	###---draw vision cone---###
	draw_arc(to_local(position), 40.0, deg2rad(sight_angle + 45), deg2rad(sight_angle - 45), 10,Color.orange, 3.0, true) #0.0 when right 180 when left
	
	#make a extra node which draws the circl
	draw_circle(to_local(position), 20.0, current_color)
	
	
	###---this is for drawing the sight radius/form---###
#	var pool : PoolVector2Array
#	pool.append(Vector2(0,0))
#	pool.append(Vector2(40,40))
#	pool.append(Vector2(40,80))
#	var color_pool : PoolColorArray
#	color_pool.append(Color.red)
#	color_pool.append(Color.green)
#	color_pool.append(Color.blue)
#	draw_colored_polygon(pool, Color.red)
	pass

func _on_sight_body_entered(body):
	if body.is_in_group("player"):
		player = body
		pass
	pass

func _on_sight_body_exited(body):
	player = null
	pass
