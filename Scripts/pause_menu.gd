extends Control
@export var GameController: Node2D
@export var volumeCurve: Curve

var musicFadeInTimer: float

func pause():
	$Music.play()

func _input(event):
	if event.is_action("quit"):
		_on_continue_button_pressed()



func _process(delta):
	if self.visible && musicFadeInTimer < 10:
		musicFadeInTimer += delta
		AudioServer.set_bus_volume_db(3, volumeCurve.sample(musicFadeInTimer / 10))
		print(AudioServer.get_bus_volume_db(3))

func _on_continue_button_pressed():
	AudioServer.set_bus_volume_db(3,-72)
	musicFadeInTimer = 0
	
	GameController.continue_game()
	self.hide()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Title.tscn")


func _on_master_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, volumeCurve.sample(value / 100))


func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, volumeCurve.sample(value / 100))


func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, volumeCurve.sample(value / 100))
