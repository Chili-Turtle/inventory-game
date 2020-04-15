extends Light2D

var rate = 0.0

func _ready():
	randomize()
	pass
	
func _process(delta):
	pass


func _on_Timer_timeout():
	rate = rand_range(0.0, 1)
	texture_scale = 0.15 + (abs(sin(rate)) / 8.0)
	pass
