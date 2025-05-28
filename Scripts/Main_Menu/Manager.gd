extends Control;
var mainScene: PackedScene = preload("res://Scenes/main.tscn");

const scoreEntry = preload("res://scoreEntry.gd");

func _ready() -> void:
	var highscore: int = 0;
	var highName: String = "NUL";
	var file = FileAccess.open("user://scores.dat", FileAccess.READ);
	if file:
		var scores: Array[scoreEntry] = file.get_var(true);
		if not scores == []:
			highscore = scores[0].score;
			highName = scores[0].name;
	$HighScore.text = "Highscore [color=yellow][b] %d[/b][color=white]   %s" % [highscore, highName];

func Play() -> void:
	get_tree().paused = false;
	$AudioStreamPlayer.play();
	$AnimationPlayer.play("Fade_out");

func Quit() -> void:
	get_tree().quit();


func startGame(_anim_name):
	get_tree().change_scene_to_packed(mainScene);
