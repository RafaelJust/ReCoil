extends Control

@export var colorRamp: Curve

@onready var shell1: TextureProgressBar = $Shell1/TextureProgressBar
@onready var shell2: TextureProgressBar = $Shell2/TextureProgressBar
@onready var cooldown: Timer = get_node("/root/Main/Player/Cooldown")
@onready var player: Node2D = get_node("/root/Main/Player")

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
