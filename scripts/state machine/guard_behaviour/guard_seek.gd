extends "res://scripts/state machine/state.gd"

func enter():
#	print("%s entered" %name)
	owner.get_node("state_machine").change_state("move")
	pass
	
func exit():
#	print("%s entered" %name)
	pass
	
func update(_delta : float):
	get_scent_direction()
	detect_scent_trail()
	pass

func handle_input(_event):
	pass

func get_scent_direction():
	if owner.last_scent != null:
		owner.direction = owner.last_scent.position - owner.position
		owner.direction = owner.direction.normalized()
	pass

func detect_scent_trail():
	if owner.scent_path.size() <= 0:
		owner.get_node("behaviour_tree").change_state("patrol")
		return
	
	for scent in owner.scent_path:
		if owner.last_scent == null:
			owner.last_scent = scent
			continue
		
		####---take the furthest---###
#		if last_scent.position.distance_to(position) < scent.position.distance_to(position):
#			last_scent = scent
#			target = scent.position
#		else: #delete the scent from the array if it isn't the furthest
#			scent_path.erase(scent)
		###------###
		
		owner.target = owner.last_scent.position
		
		###---nearest point---###
		if owner.last_scent.position.distance_to(owner.position) > scent.position.distance_to(owner.position):
			owner.last_scent = scent
			owner.target = scent.position
			
		if owner.last_scent.position.distance_to(owner.position) <= 2.0:
			owner.scent_path.erase(scent)
			owner.last_scent = null
