extends RigidBody2D

func shoot(force: float, life:float) -> void:
	
	# Apply the force
	apply_central_force(Vector2.from_angle(rotation) * force)
	
	%Life.wait_time = life + randf_range(0,0.5) # Add some randomness to the timer
	%Life.start()

func _physics_process(_delta: float) -> void:
	var dir: Vector2 = linear_velocity
	%Body.look_at(position + dir)


func _on_life_timeout() -> void:
	queue_free()
