extends RigidBody2D

var player: Node2D

func _ready() -> void:
	player = get_node("/root/Main/Player")
	if player != null:
		print("Works!")
	else:
		print("Go cry in a corner")

func  _physics_process(_delta: float) -> void:
	pass # TODO: Move towards the player
