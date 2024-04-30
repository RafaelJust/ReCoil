extends RigidBody2D

var initialForce: float

func shoot() -> void:
	apply_central_force(Vector2.from_angle(rotation) * initialForce)
	%Life.wait_time = randf_range(1,3)
	%Life.start()

func _physics_process(_delta: float) -> void:
	var dir: Vector2 = linear_velocity
	%Body.look_at(position + dir)


func _on_life_timeout() -> void:
	queue_free()
