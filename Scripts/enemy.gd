extends RigidBody2D

@export var force: int = 1000
var player: Node2D

func _ready() -> void:
	player = get_node("/root/Main/Player")
	
	self.add_to_group("Enemies")

func  _physics_process(_delta: float) -> void:
	# Make a Vector2 that points into the direction of the player
	var dir: Vector2 = (player.global_position - self.global_position).normalized()
	
	#Apply force into that direction
	apply_central_force(dir * force)
