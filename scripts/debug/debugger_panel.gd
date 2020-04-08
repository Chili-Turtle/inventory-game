extends Panel

export(int) var framerate = 120
export(float) var time_scale = 1.0

func _ready():
	Engine.set_target_fps(framerate)
	Engine.set_time_scale(time_scale)
	
	$time_scale.text = "time scale " + str(Engine.get_time_scale())
	pass

func _process(delta):
	$fps_counter.text = "FPS: " + str(Engine.get_frames_per_second())
	
