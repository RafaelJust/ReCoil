extends RigidBody2D

var initialForce: float

func shoot() -> void:
	print(initialForce)
	apply_central_force(Vector2.from_angle(rotation) * initialForce)
