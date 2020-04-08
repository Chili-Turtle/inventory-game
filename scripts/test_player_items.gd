extends Control

func _ready():
#	hide()
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("steal"):
		show()
	pass


func _on_Area2D_body_exited(body):
	if body.is_in_group("steal"):
		hide()
	pass 
