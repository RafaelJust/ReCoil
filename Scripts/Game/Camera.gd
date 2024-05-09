extends Camera2D

# Curve vars
@export var shakeCurve: Curve
var shakePos: float

@onready var shakeTimer: Timer = $Shaketime

func shakeScreen(duration: float, strength: float) -> void:
	shakeCurve.set_point_value(0,strength)
	shakeTimer.wait_time = duration
	shakeTimer.start()

func _physics_process(_delta: float) -> void:
	if shakeTimer.time_left > 0:
		#get the shake strength
		var shakeStrength: float = shakeCurve.sample(1 - (shakeTimer.time_left * shakeTimer.wait_time))
		#Shake the screen
		self.position = Vector2(randf_range(-1,1) * shakeStrength, randf_range(-1,1) * shakeStrength)
