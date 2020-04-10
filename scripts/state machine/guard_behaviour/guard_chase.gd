extends "res://scripts/state machine/state.gd"

func enter():
#	print("%s entered" %name)
	owner.get_node("state_machine").change_state("move")
	pass
	
func exit():
#	print("%s entered" %name)
	pass
	
func update(_delta : float):
	chase_player()
	chatch_player()
	pass

func handle_input(_event):
	pass
	
func chase_player():
	if owner.player == null:
#		owner.get_node("behaviour_tree").change_state("seek")
		return
	
	owner.direction = owner.player.position - owner.position
	owner.direction = owner.direction.normalized()

func chatch_player():
	if owner.player == null:
		owner.get_node("behaviour_tree").change_state("seek")
		return
		
	if owner.position.distance_to(owner.player.position) <= 10.0:
		print("player captured")
		owner.player.take_damage(owner, 1, 500.0)
		#add a knockback/forward to the player
		#damage the player
	pass
