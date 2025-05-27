extends Control;
var mainScene: PackedScene = preload("res://Scenes/main.tscn");

const scoreEntry = preload("res://scoreEntry.gd");

func _ready() -> void:
	var highscore = 0;
	var file = FileAccess.open("user://scores.dat", FileAccess.READ);
	if file:
		var scores: Array[scoreEntry] = file.get_var(true);
		highscore = scores == [] if 0 else scores[0].score;
	$HighScore.text = "Highscore [color=yellow][b] %d" % highscore

func Play() -> void:
	get_tree().paused = false;
	$AudioStreamPlayer.play();
	$AnimationPlayer.play("Fade_out");

func Quit() -> void:
	get_tree().quit();


func startGame(_anim_name):
	get_tree().change_scene_to_packed(mainScene);
