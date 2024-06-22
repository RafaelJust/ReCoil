extends Control
var mainScene: PackedScene = preload("res://Scenes/main.tscn")

func Play() -> void:
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Fade_out")

func Quit() -> void:
	get_tree().quit()


func startGame(anim_name):
	get_tree().change_scene_to_packed(mainScene)
