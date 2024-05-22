extends Control
var mainScene: PackedScene = preload("res://Scenes/main.tscn")

func Play() -> void:
	get_tree().change_scene_to_packed(mainScene)

func Quit() -> void:
	get_tree().quit()
