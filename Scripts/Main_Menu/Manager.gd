extends Control;
var mainScene: PackedScene = preload("res://Scenes/main.tscn");

const scoreEntry = preload("res://scoreEntry.gd");
@export var volumeCurve: Curve
var musicFadeInTimer: float = 0

var in_options = false

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
	$mainMenu/HighScore.text = "Highscore [color=yellow][b] %d[/b][color=white]   %s" % [highscore, highName];
	load_options()

func Play() -> void:
	get_tree().paused = false;
	$AudioStreamPlayer.play();
	$AnimationPlayer.play("Fade_out");

func Quit() -> void:
	get_tree().quit();


func startGame(anim_name):
	if anim_name == "Fade_out":
		get_tree().change_scene_to_packed(mainScene);
	if anim_name == "wipe_to_options":
		in_options = true
	if anim_name == "wipe_to_main":
		in_options = false
		musicFadeInTimer = 0
		AudioServer.set_bus_volume_db(3,-72)

func _process(delta: float) -> void:
	if in_options && musicFadeInTimer < 10:
		musicFadeInTimer += delta * 2
		AudioServer.set_bus_volume_db(3, volumeCurve.sample(musicFadeInTimer / 10))

func _on_options_button_pressed() -> void:
	$AnimationPlayer.play("wipe_to_options")
