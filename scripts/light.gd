extends Light2D

var rate = 0.0

func _ready():
	pass
	
func _process(delta):
	pass


func _on_Timer_timeout():
	rate += 0.1
	texture_scale = 0.15 + (abs(sin(rate)) / 10.0)
	pass # Replace with function body.
