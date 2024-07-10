extends Control
@export var GameController: Node2D
@export var volumeCurve: Curve

var musicFadeInTimer: float

func _process(delta):
	if self.visible && musicFadeInTimer < 10:
		musicFadeInTimer += delta
		$Music.volume_db = volumeCurve.sample(musicFadeInTimer / 10)
	elif musicFadeInTimer > 0:
		musicFadeInTimer = 0
		$Music.volume_db = -72

func _on_continue_button_pressed():
	GameController.continue_game()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Title.tscn")


func _on_master_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, volumeCurve.sample(value / 100))


func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, volumeCurve.sample(value / 100))


func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, volumeCurve.sample(value / 100))
