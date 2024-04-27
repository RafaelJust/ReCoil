extends RigidBody2D

var initialForce: float

func _onready() -> void:
	apply_central_force(Vector2.from_angle(rotation) * initialForce)
