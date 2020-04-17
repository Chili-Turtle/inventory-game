extends Node2D

var index : int = 0

var gold_value : float = 0.0

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if body.current_inventory_space > 0 || index > 0:
			if check_inventory(body) >= 300.0:
				get_tree().change_scene("res://scenes/cut_scene_2.tscn")
			else:
				get_tree().change_scene("res://scenes/cut_scene_3.tscn")
		elif index == 0:
			event_handler.emit_signal("load_dialogue", "You have to steal items, or do you wanna leave without stealing and don't rescue your sister?", "Important")
			index += 1
#		get_tree().change_scene()
	pass

func check_inventory(body):
	var item_value : float = 0.0
	for item_inx in body.inventory:
		if body.inventory[item_inx] != null:
#			gold_value += Database.item_database[body.inventory[item_inx]].item_value
			item_value += Database.item_database[body.inventory[item_inx]].item_value
			print(item_value)
	
	return item_value
	pass
