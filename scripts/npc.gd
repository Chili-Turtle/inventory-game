extends KinematicBody2D

export var ray_length : float = 30.0

var inventory : Dictionary = {}

var current_inventory_space = 0
var max_inventory_space = 9

var velocity : Vector2

var direction : Vector2

export(Array, String) var item_to_add = []

#var speed : float = 0.0 #20

var suspicion_value = 0

var index = 0

var sight_angle = 0.0

var angle = 0

var player = null

var hit_point = Vector2()

var steering : Vector2 = Vector2()

var can_steal = true

export(NodePath) var patrole_path = null

var patrole_curve : Curve2D

func _ready():
	
	if patrole_path != null:
		patrole_curve = get_node(patrole_path).get_curve()
	
	init_inventory()
	
	for i in item_to_add.size():
		add_item(item_to_add[i])
		pass
	
	$CanvasLayer/button_prompt.visible = false
	pass

func on_pick_pocket_noticed():
	pass

func init_inventory():
	for i in range(0, max_inventory_space + 1):
		inventory[i] = null
	pass

func add_item(item_name):
	for key in inventory:
		if inventory[key] == null:
			inventory[key] = item_name
			return
	print("inventory is full")
	pass
	
func remove_item(item_name):
	for key in inventory:
		if inventory[key] == item_name:
			inventory[key] = null
			break
	pass

func _process(delta):
	angle -= delta * 500.0
	update()
	is_player_in_vision()
	
	if suspicion_value >= 100.0:
		can_steal = false
		print("can_steal %s" %can_steal)
	
	$CanvasLayer/button_prompt.rect_position = to_global($Position2D.position)
	$CanvasLayer/exclamation_mark.rect_position = to_global($Position2D.position)
	pass
	
func add_suspicion(value : float):
	suspicion_value += value
	pass
	
func is_player_in_vision(): #this should be a bool
	if player == null:
		return
	
	$CanvasLayer/button_prompt.visible = true
	
	#cone right
	if sight_angle == 0.0:
		if player.position.angle_to_point(position) <= deg2rad(45) && player.position.angle_to_point(position) >= deg2rad(-45):
			var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self])
			if !ray.empty():
				if ray.collider.is_in_group("player"):
					$CanvasLayer/button_prompt.visible = false
					if player.is_stealing == true:
						player.cancel_stealing()
						suspicion_value += 50
						event_handler.emit_signal("alert_guards")
						$exclamation_anim.play("exclamation_anim")
	
	#cone left
	if sight_angle == 180.0:
		if player.position.angle_to_point(position) <= deg2rad(180) && player.position.angle_to_point(position) >= deg2rad(135) || \
		   player.position.angle_to_point(position) <= deg2rad(-135) && player.position.angle_to_point(position) >= deg2rad(-180):
			var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self])
			if !ray.empty():
				if ray.collider.is_in_group("player"):
					$CanvasLayer/button_prompt.visible = false
					if player.is_stealing == true:
						player.cancel_stealing()
						suspicion_value += 50
						event_handler.emit_signal("alert_guards")
						$exclamation_anim.play("exclamation_anim")
	#cone up
	if sight_angle == -90.0:
		if player.position.angle_to_point(position) <= deg2rad(-45) && player.position.angle_to_point(position) >= deg2rad(-135):
			var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self])
			if !ray.empty():
				if ray.collider.is_in_group("player"):
					$CanvasLayer/button_prompt.visible = false
					if player.is_stealing == true:
						player.cancel_stealing()
						suspicion_value += 50
						event_handler.emit_signal("alert_guards")
						$exclamation_anim.play("exclamation_anim")
	#cone down
	if sight_angle == 90.0:
		if player.position.angle_to_point(position) <= deg2rad(135) && player.position.angle_to_point(position) >= deg2rad(45):
			var ray = get_world_2d().direct_space_state.intersect_ray(position, player.position, [self])
			if !ray.empty():
				if ray.collider.is_in_group("player"):
					$CanvasLayer/button_prompt.visible = false
					if player.is_stealing == true:
						player.cancel_stealing()
						suspicion_value += 50
						event_handler.emit_signal("alert_guards")
						$exclamation_anim.play("exclamation_anim")
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
	###---draw vision cone arc---###
	draw_arc(to_local(position), 40.0, deg2rad(sight_angle + 45), deg2rad(sight_angle - 45), 10,Color.orange, 3.0, true) #0.0 when right 180 when left
	pass

func _on_sight_body_entered(body):
	if body.is_in_group("player"):
		player = body
		$CanvasLayer/button_prompt.visible = true
		pass
	pass

func _on_sight_body_exited(body):
	player = null
	$CanvasLayer/button_prompt.visible = false
	pass
