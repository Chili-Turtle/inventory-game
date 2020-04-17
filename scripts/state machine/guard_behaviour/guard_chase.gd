extends "res://scripts/state machine/state.gd"

var chase_clip = load("res://audio/music/chase_music_1.wav")

func enter():
	owner.get_node("state_machine").change_state("move")
	
	owner.get_node("AudioStreamPlayer").play()
	
	MM.play_music(chase_clip)
	pass
	
func exit():
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
		owner.player.take_damage(owner, 1, 500.0)
	pass
