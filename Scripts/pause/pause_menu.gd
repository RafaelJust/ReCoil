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

func _on_continue_button_pressed():
	AudioServer.set_bus_volume_db(3,-72)
	musicFadeInTimer = 0
	
	GameController.continue_game()
	self.hide()


func _on_exit_button_pressed():
	get_node("/root/Main/UI/SceneTransition").transition("res://Scenes/Title.tscn");
