extends Control

@export var colorRamp: Curve

@export var tutorialText: Array[String]
var currentTutorial: int = 0

@onready var shell1: TextureProgressBar = %Shell1_progress
@onready var shell2: TextureProgressBar = %Shell2_progress

@onready var cooldown: Timer = get_node("/root/Main/Player/Cooldown")
@onready var player: Node2D = get_node("/root/Main/Player")

@onready var WaveText: RichTextLabel = $WaveNum

# Other scripts use this function instead of directly editing it for stability
func show_lives(lives: int) -> void:
	if lives == 2:   %life1.visible = false
	elif lives == 1: %life2.visible = false
	elif lives == 0: %life3.visible = false

# Flashes the correct wave number on the screen.
func show_wave(waveNum: int) -> void:
	for i in range(3):
		WaveText.text = "[center]WAVE"
		$WAVEANIM.stop()
		$WAVEANIM.play("WAVE_splash")
		await get_tree().create_timer(0.5).timeout
		WaveText.text = "[center] %d" % waveNum
		$WAVEANIM.stop()
		$WAVEANIM.play("WAVE_splash")
		await get_tree().create_timer(0.5).timeout
	WaveText.text = ""

func changeTutorialText():
	currentTutorial += 1;
	if currentTutorial > 3:
		$Tutorial.queue_free()
		return
	else: 
		%TutorialText.text = "[center]" + tutorialText[currentTutorial]

func _process(_delta: float) -> void:
	var progress: float = (cooldown.time_left / cooldown.wait_time)
	#Link reload timer to correct progress bar
	if player.usedShots == 1:
		shell1.value = 100 - (progress * 100)
		
		# Get the correct color value for shell 1, and apply it
		var color1: float = colorRamp.sample(1 - progress)
		shell1.modulate = Color(color1,color1,color1)
	elif player.usedShots == 2:
		shell1.value = 0
		shell2.value = 100 - ((cooldown.time_left / cooldown.wait_time) * 100)
		
		# Get the correct color value for shell 2, and apply it
		var color2: float = colorRamp.sample(1 - progress)
		shell2.modulate = Color(color2,color2,color2)

# Load title screen after Dying
func _on_game_over_anim_animation_finished(anim_name):
	if anim_name=="Out":
		#Clear all nodes first, because collision objects can't be present when changing scene
		for n: Node in get_node("/root/Main").get_children():
			if n.name != "UI":
				n.queue_free()
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://Scenes/Title.tscn")
