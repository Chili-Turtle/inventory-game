extends Control

var main_music = load("res://audio/music/Terrible Fate (fade).wav")
var main_music_2 = load("res://audio/music/chase_music_2.wav")
var main_music_3 = load("res://audio/music/chase_music_1.wav")

func _ready():
	$back_ground/options.visible = false
	
	$back_ground/VBoxContainer/exit_button/ColorRect3.visible = false
	$back_ground/VBoxContainer/option_button/ColorRect2.visible = false
	$back_ground/VBoxContainer/Start_button/ColorRect.visible = false
	$back_ground/VBoxContainer/tutorial_button/ColorRect.visible = false
	
	update_options()
	
	MM.play_music(main_music)
	pass

func _input(event):
#	if event.is_action_pressed("ui_down"):
#		MM.play_music(main_music_2)
#	if event.is_action_pressed("ui_up"):
#		MM.play_music(main_music_3)
		pass


func _on_tutorial_button_pressed():
	get_tree().change_scene("res://scenes/tutorial.tscn")
	pass
	

func _on_Start_button_pressed():
	get_tree().change_scene("res://scenes/cut_scene.tscn")
	pass

func _on_option_button_pressed():
	$back_ground/options.visible = true
	pass 

func _on_exit_button_pressed():
	get_tree().quit()
	pass 

func _on_Volumen_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	pass

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	pass

func _on_SFX_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	pass
	
func update_options():
	$back_ground/options/Volumen.value = AudioServer.get_bus_volume_db(0)
	$back_ground/options/Music.value = AudioServer.get_bus_volume_db(1)
	$back_ground/options/SFX.value = AudioServer.get_bus_volume_db(2)
	pass

func _on_option_exit_button_pressed():
	$back_ground/options.visible = false


func _on_Start_button_mouse_entered():
	$back_ground/VBoxContainer/Start_button/ColorRect.visible = true
	pass


func _on_Start_button_mouse_exited():
	$back_ground/VBoxContainer/Start_button/ColorRect.visible = false
	pass


func _on_option_button_mouse_entered():
	$back_ground/VBoxContainer/option_button/ColorRect2.visible = true
	pass


func _on_option_button_mouse_exited():
	$back_ground/VBoxContainer/option_button/ColorRect2.visible = false
	pass


func _on_exit_button_mouse_entered():
	$back_ground/VBoxContainer/exit_button/ColorRect3.visible = true
	pass


func _on_exit_button_mouse_exited():
	$back_ground/VBoxContainer/exit_button/ColorRect3.visible = false
	pass


func _on_tutorial_button_mouse_entered():
	$back_ground/VBoxContainer/tutorial_button/ColorRect.visible = true
	pass


func _on_tutorial_button_mouse_exited():
	$back_ground/VBoxContainer/tutorial_button/ColorRect.visible = false
	pass 
