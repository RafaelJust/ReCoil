extends Control;
var mainScene: PackedScene = preload("res://Scenes/main.tscn");

func _ready() -> void:
	var highscore = 0;
	var file = FileAccess.open("user://scores.dat", FileAccess.READ);
	if file:
		highscore = file.get_64()
	$HighScore.text = "Highscore [color=yellow][b] %d" % highscore

func Play() -> void:
	get_tree().paused = false;
	$AudioStreamPlayer.play();
	$AnimationPlayer.play("Fade_out");

func Quit() -> void:
	get_tree().quit();


func startGame(_anim_name):
	get_tree().change_scene_to_packed(mainScene);
