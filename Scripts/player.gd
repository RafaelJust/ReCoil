extends RigidBody2D

const STRENGTH: int = 10000
var shootAngle: int = 20 #using degrees for convenience
var bulletsPerShot: int = 10

var bullet: PackedScene

func _ready() -> void:
	print(STRENGTH)
	bullet = preload("res://Objects/bullet.tscn")

func shoot() -> void:
	
	# Get the current rotation, and apply force to the opposite way.
	var dir: Vector2 = Vector2.RIGHT.from_angle(rotation)
	apply_central_force(dir * -STRENGTH) # Make the force negative to simulate recoil

func _input(event: InputEvent) -> void:
	if event.is_action("Fire"):
		shoot()

func _physics_process(delta: float) -> void:
	var MousePos: Vector2 = get_global_mouse_position()
	look_at(MousePos)
