extends Control
@export var GameController: Node2D

func _on_continue_button_pressed():
	GameController.continue_game()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Title.tscn")
