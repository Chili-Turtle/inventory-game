extends StaticBody2D

var inventory_GUI = load("res://scenes/GUI/Inventory.tscn")
var item_containers = load("res://scenes/item_container.tscn")

var inventory_gui
var is_looted : bool = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		show_inventory(body)
		for index in body.inventory:
			if body.inventory[index] == "sword" && is_looted == false:
				body.add_item("hammer")
				event_handler.emit_signal("display_dialogue", "You received a hammer")
				inventory_gui.queue_free()
				show_inventory(body)
				is_looted = true
				break

		if is_looted == false:
			event_handler.emit_signal("display_dialogue", "I NEED A KEY")
	pass

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		inventory_gui.queue_free()
	pass

func show_inventory(player):
	inventory_gui = inventory_GUI.instance()
	get_tree().root.get_node("root scene").get_node("CanvasLayer/inventory_space").add_child(inventory_gui)
	
	inventory_gui.rect_position = Vector2(300.0, 400.0)
	inventory_gui.name = "player_inventory"
	init_slots(inventory_gui)
	for key in player.inventory:
		if player.inventory[key] != null:
			add_item(inventory_gui, player.inventory[key])
	
func init_slots(_gui_inv):
	var slots = _gui_inv.get_node("MarginContainer/HBoxContainer/slots")
	for i in range(0, 9):
		var slot = item_containers.instance()
		slot.slot_index = i
		slots.add_child(slot)
		slot.connect("slot_pressed", self, "_on_item_slot_pressed")
	
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
			item_area.position +=item.rect_size/2.0
			var shape = CollisionShape2D.new()
			item_area.add_child(shape)
			shape.shape = CircleShape2D.new()
			shape.shape.radius = 15.0
			break
