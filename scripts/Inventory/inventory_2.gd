extends Control

var item
var holding_item = null

func _ready():
#	self.hide()
	Engine.set_target_fps(60)
	Engine.set_time_scale(1.0)
	pass
	
func mouse_enter_slot(slot):
	pass
	
func mouse_exit_slot(slot):
	pass

func _process(delta):
	$Label.text = str(Engine.get_frames_per_second())


func gui_input(event, slot):
	if event is InputEventMouseButton:
		if get_node("MarginContainer/item_slots/" + slot).get_child_count() >= 1:
			#just use remove_child(item), this should be in the item slot
			item = get_node("MarginContainer/item_slots/" + slot).get_child(0)
			get_node("MarginContainer/item_slots/" + slot).remove_child(item)
#			get_tree().get_root().add_child(item) #move_child()
			get_tree().get_root().get_node("bar 1/CanvasLayer").add_child_below_node(get_tree().get_root(), item)
			holding_item = item
			#print("I got pressed")
			item.position = get_global_mouse_position()
	pass

func _input(event):
	if event is InputEventMouseMotion && holding_item != null:
		holding_item.position = event.position
	if event is InputEventMouseButton && holding_item != null:
		if event.is_pressed():
			holding_item = null
	elif event is InputEventMouseButton && holding_item == null:
		if event.is_pressed():
			holding_item = item
			pass
	pass


func _on_pick_pocket_range_body_entered(body):
	if body.is_in_group("player"):
		self.show()
	pass


func _on_pick_pocket_range_body_exited(body):
	if body.is_in_group("player"):
		self.hide()
	pass


func _on_Area2D_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.is_in_group("steal"):
		pass 

func _on_Area2D_area_entered(area):
	pass 
