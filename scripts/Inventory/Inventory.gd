extends Control

"""
Rewrite the inventory,so inventory and Area2Ds are seperated
when item clicked spawn a Area2D instead using the Control nodes

"""

var world_state

var is_locked = true
var is_pocketing = false

var inventory : Dictionary = {0 : {"item_name": "sword", "item_value":100, "width":60}}

var inventory_GUI = load("res://scenes/GUI/Inventory.tscn")
var item_containers = load("res://scenes/item_container.tscn")

var selected_item = null

var mouse_offset : Vector2

var last_slot

var is_invincible = false

var index = 0

var inventory_gui_npc
var inventory_gui_player

var npc 
var player

var state = "none"

var trans = Color(0.0,0.0,0.0,0.0)
var col = Color(1.0,1.0,1.0,1.0)

func _ready():
	event_handler.connect("pick_pocket_started", self, "_on_pick_pocket_started")
	event_handler.connect("pick_pocket_ended", self, "_on_pick_pocket_ended")
	
	event_handler.connect("pocketing_started", self,"start_pocketing")
	event_handler.connect("pocketing_canceled", self, "on_pocketing_canceled")
	event_handler.connect("pocketing_ended", self, "on_pocketing_ended")
	
	$notice_bar.visible = false
	get_parent().get_node("vignette").visible = false
	pass
	
func _on_pick_pocket_started(_npc, _player):
	npc = _npc
	player = _player
	
	$Line2D.is_started = false
	$Line2D.is_checked = false
	
	get_parent().get_node("vignette").visible = true
	get_parent().get_node("vignette/AnimationPlayer").play("vignette_fade_in")
	
	for i in range(0, 2):
		var gui_inv = inventory_GUI.instance()
		#inventory_GUI.inventory = npc #or the first dic
		add_child(gui_inv)
		#if it is the first inventory or the second
		if i == 0: #npc invnetory
			gui_inv.rect_position = Vector2(50.0, 50.0)
			inventory_gui_npc = gui_inv
			inventory_gui_npc.name = "npc_inventory"
			init_slots(gui_inv)
			$notice_bar.visible = true
			$notice_bar.value = npc.suspicion_value
			for key in npc.inventory:
				if npc.inventory[key] != null:
					add_item(gui_inv, npc.inventory[key])
		else: #player inventory
			gui_inv.rect_position = Vector2(300.0, 400.0)
			inventory_gui_player = gui_inv
			inventory_gui_player.name = "player_inventory"
			init_slots(gui_inv)
			for key in player.inventory:
				if player.inventory[key] != null:
					add_item(gui_inv, player.inventory[key])
			
	pass
	
func _on_pick_pocket_ended(_npc, _player):
	
	if state == "holding":
		go_to_last_slot()
		$Line2D.clear_path()
		is_locked = true
		
	if inventory_gui_player == null:
		return

	is_pocketing = false
	get_parent().get_node("vignette/AnimationPlayer").play("vignette_fade_out")
	$Line2D.is_started = false
	inventory_gui_player.call_deferred("queue_free")
	inventory_gui_npc.call_deferred("queue_free")
	$notice_bar.visible = false
	inventory_gui_player = null
	inventory_gui_npc = null
	npc = null
	player = null
	selected_item = null
	state = "none"
	pass

func init_slots(_gui_inv):
	var slots = _gui_inv.get_node("MarginContainer/HBoxContainer/slots")
	for i in range(0, 9):
		var slot = item_containers.instance()
		slot.slot_index = i
		slots.add_child(slot)
		slot.connect("slot_pressed", self, "_on_item_slot_pressed")
	pass

#put item into the spec slot. but first check if it is empty
func add_item(_gui_inv, item_name : String): #add item to the dic and slot // should I make an add_item_on_slot_index func?
	#look for empty slot
	var slots = _gui_inv.get_node("MarginContainer/HBoxContainer/slots")
	for slot in slots.get_children():
		if slot.item == null: #empty slot found
			var item = Item.new(Database.item_database[item_name].item_name,
			 Database.item_database[item_name].item_value,
			 Database.item_database[item_name].item_width)
			
			item.texture = load("res://sprites/item_icons/" + item_name + ".png")
			item.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			slot.add_child(item)
			slot.item = item
			
			#add collision stuff & set position of area2D
			var item_area = Area2D.new()
			item.add_child(item_area)
			item_area.add_to_group("item")
			item_area.position += slot.rect_size/2.0
			slot.force_update_transform()
			var shape = CollisionShape2D.new()
			item_area.add_child(shape)
			shape.shape = CircleShape2D.new()
			shape.shape.radius = 15.0
			break
		pass

func _on_item_slot_pressed(slot):
	match state:
		"none":
			if slot.item == null:
				return
				
			match slot.get_node("../../../..").name:
				"npc_inventory":
					npc.remove_item(slot.item.item_name)
				"player_inventory":
					if is_locked == true:
						return
					player.remove_item(slot.item.item_name)
			
			last_slot = slot
			selected_item = slot.item
			slot.item = null
			slot.remove_child(slot.get_child(0))
			add_child(selected_item)
			state = "holding"
			
			mouse_offset = slot.get_global_position() - get_global_mouse_position()
			
#			var start_point = Vector2(inventory_gui_npc.rect_position.x + (inventory_gui_npc.rect_size.x / 2.0), inventory_gui_npc.rect_size.y - 10.0) #use this if the line2D is not in the canvas
			var start_point = Vector2(inventory_gui_npc.get_rect().position.x + inventory_gui_npc.get_rect().size.x / 2.0, inventory_gui_npc.get_rect().position.y + inventory_gui_npc.get_rect().size.y)
			var end_point = Vector2(inventory_gui_player.get_rect().position.x, inventory_gui_player.get_rect().position.y + inventory_gui_player.get_rect().size.y / 2.0)
			
			#create line from inventory 1 to inventory 2
			$Line2D.add_point(start_point)
			$Line2D.add_point(end_point)
			$Line2D.width = selected_item.item_width #later item width
			random_path()
			$Line2D.create_collision()
	
		"holding":
			if slot.item != null:
				return
			
			slot.item = selected_item
			$Line2D.is_started = false
			$Line2D.is_checked = false
			
			#remove_child
			match slot.get_node("../../../..").name:
				"npc_inventory":
					npc.add_item(slot.item.item_name)
				"player_inventory":
					
					if is_locked == true:
						return
						
					is_locked = true
					player.add_item(slot.item.item_name)
			
			
			remove_child(selected_item)
			slot.add_child(selected_item)
			selected_item.rect_position = Vector2(0.0, 0.0)
			selected_item = null
			last_slot = null
			state = "none"
			
			#delete line
			$Line2D.clear_path()
			
			#remove the item from npc
			#add the item to the player
	pass

func go_to_last_slot():
	
	last_slot.item = selected_item
	
	match last_slot.get_node("../../../..").name:
			"npc_inventory":
				npc.add_item(last_slot.item.item_name)
			"player_inventory":
				player.add_item(last_slot.item.item_name)
	
	
	last_slot.item.queue_free()
	last_slot = null
	
func random_path():
	randomize()
	
	match index %3:
		0:
			path_generation_cur_dir_angle() #easy
#			print("generate 'cur dir angle'")
		1:
			path_generation_rand_offset() #medium
#			print("generate 'rand offset'")
		2:
			path_generation_dir_angle() #hard path
#			print("generate 'dir angle'")
		_:
			print("not path to generate")
	
	index +=1

func path_generation_cur_dir_angle(resolution = 4):
	var dir = $Line2D.points[$Line2D.get_point_count()-1] - $Line2D.points[0]
	var length = dir.length()
	length = length / resolution

	var add_length : Vector2 = $Line2D.points[0]
	for i in range(0, resolution):
		
		
		#initialize points
		add_length += dir.normalized()*length
		$Line2D.add_point(add_length, i+1)

		#add the offset to the line
		if i == 0:
			$Line2D.points[i+1].x = $Line2D.points[0].x
			$Line2D.points[i+1].y = $Line2D.points[0].y + dir.normalized().y*length
			continue
			
		var rand_angle = rand_range(-40, 40)
		var cur_dir_rot = Vector2(0.0, 1.0).rotated(deg2rad(rand_angle))
		$Line2D.points[i+1] = $Line2D.points[i] + cur_dir_rot * length
			
		if i == resolution - 1:
			$Line2D.points[$Line2D.get_point_count()-2].x = $Line2D.points[$Line2D.get_point_count()-1].x - dir.normalized().x*length #+ rand_range(-100, 100.0)
			$Line2D.points[$Line2D.get_point_count()-2].y = $Line2D.points[$Line2D.get_point_count()-1].y
		
		pass
	pass
	
func on_bumped_in(area):
	if npc != null && is_pocketing == true && is_invincible == false:
		if area.is_in_group("item"):
			event_handler.emit_signal("start_canvas_shake", 0.5)
			npc.suspicion_value += 20.0
			$AudioStreamPlayer.play()
			is_invincible = true
			$invincibility_timer.start()
	pass
	

func path_generation_rand_offset(resolution = 4):
	var dir = $Line2D.points[$Line2D.get_point_count()-1] - $Line2D.points[0]
	var length = dir.length()
	length = length / resolution

	var add_length : Vector2 = $Line2D.points[0]
	for i in range(0, resolution):


		###---generator function---### add an offset to the line points
		#is not that extrem
		add_length += dir.normalized()*length
		$Line2D.add_point(add_length, i+1)
		#has some extreams, but easy too easy
#		$Line2D.add_point($Line2D.points[i] + dir.normalized()*length, i+1) #just another method for adding length, changes the outcome

		#add the offset to the line
		if i == 0:
			$Line2D.points[i+1].x = $Line2D.points[0].x
			$Line2D.points[i+1].y = $Line2D.points[0].y + dir.normalized().y*length# + rand_range(-100, 100.0)
			continue


		$Line2D.points[i+1].y += rand_range(-80, 80.0)
		$Line2D.points[i+1].x += rand_range(-length/2.0, -20.0)

		if i == resolution - 1:
			$Line2D.points[$Line2D.get_point_count()-2].x = $Line2D.points[$Line2D.get_point_count()-1].x - dir.normalized().x*length #+ rand_range(-100, 100.0)
			$Line2D.points[$Line2D.get_point_count()-2].y = $Line2D.points[$Line2D.get_point_count()-1].y
		pass
	
func path_generation_dir_angle(resolution = 4):
	var dir = $Line2D.points[$Line2D.get_point_count()-1] - $Line2D.points[0]
	var length = dir.length()
	length = length / resolution

	var add_length : Vector2 = $Line2D.points[0]
	for i in range(0, resolution):
		
		add_length += dir.normalized()*length
		$Line2D.add_point(add_length, i+1)
		
		#first point
		if i == 0:
			$Line2D.points[i+1].x = $Line2D.points[0].x
			$Line2D.points[i+1].y = $Line2D.points[0].y + dir.normalized().y*length# + rand_range(-100, 100.0)
			continue
			
		if i == resolution-1:
			$Line2D.points[$Line2D.get_point_count()-2].x = $Line2D.points[$Line2D.get_point_count()-1].x - dir.normalized().y*length #+ rand_range(-100, 100.0)
			$Line2D.points[$Line2D.get_point_count()-2].y = $Line2D.points[$Line2D.get_point_count()-1].y
			continue
		
		var angle = rand_range(-60.0, 60.0)
		var dir_rotated : Vector2
		dir_rotated = dir.normalized()
		dir_rotated = dir_rotated.rotated(deg2rad(angle))
		$Line2D.points[i+1] = $Line2D.points[i] + dir_rotated * length
	pass

func start_pocketing():
	is_pocketing = true
	pass
	
func on_pocketing_canceled():
	$Line2D.is_started = false
	$Line2D.is_checked = false
	is_pocketing = false
	is_locked = true
	pass
	
func on_pocketing_ended():
	is_pocketing = false
	is_locked = false
	pass

#connect signal or bool
func _process(delta):
	if npc != null && is_pocketing == true:
		npc.suspicion_value += delta * 6.0
		$notice_bar.value = npc.suspicion_value
		
		if npc.suspicion_value >= $notice_bar.max_value:
			player.cancel_stealing()
		pass
	
	if selected_item != null:
		selected_item.rect_global_position = get_global_mouse_position() + mouse_offset
		pass
	pass

func _on_invincibility_timer_timeout():
	is_invincible = false
	pass
