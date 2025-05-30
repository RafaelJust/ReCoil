extends Control;
var mainScene: PackedScene = preload("res://Scenes/main.tscn");

const scoreEntry = preload("res://scoreEntry.gd");
@export var volumeCurve: Curve

# Load options from save file (for now only volume)
func load_options():
	var file = FileAccess.open("user://options.dat", FileAccess.READ)
	if not file:
		return
	AudioServer.set_bus_volume_db(0, volumeCurve.sample(file.get_8() / 100)) # Master
	AudioServer.set_bus_volume_db(1, volumeCurve.sample(file.get_8() / 100)) # Music
	AudioServer.set_bus_volume_db(2, volumeCurve.sample(file.get_8() / 100)) # SFX

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
	load_options()

func Play() -> void:
	get_tree().paused = false;
	$AudioStreamPlayer.play();
	$AnimationPlayer.play("Fade_out");

func Quit() -> void:
	get_tree().quit();


func startGame(_anim_name):
	get_tree().change_scene_to_packed(mainScene);
