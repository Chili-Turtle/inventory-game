extends "res://scripts/state machine/state.gd"

func enter():
	print("%s entered" %name)
	pass
	
func exit():
	print("%s entered" %name)
	pass
	
func update(_delta : float):
	chase_player()
	chatch_player()
	pass

func handle_input(_event):
	pass
	
func chase_player():
	if owner.player == null:
		return
	
	owner.get_node("state_machine").change_state("move")
	owner.direction = owner.player.position - owner.position
	owner.direction = owner.direction.normalized()

func chatch_player():
	if owner.player == null:
		return
		
	if owner.position.distance_to(owner.player.position) <= 10.0:
		print("player captured")
		#add a knockback/forward to the player
		#damage the player
	pass
