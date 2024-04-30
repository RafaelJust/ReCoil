extends RigidBody2D

const STRENGTH: int = 10000
var shootAngle: int = 20 #using degrees for convenience
var bulletsPerShot: int = 10

var bullet: PackedScene

func _ready() -> void:
	bullet = preload("res://Objects/bullet.tscn")

func shoot() -> void:
	# Get the current rotation, and apply force to the opposite way.
	var dir: Vector2 = Vector2.from_angle(rotation)
	apply_central_force(dir * -STRENGTH) # Make the force negative to simulate recoil
	
	var shootAngleRad: float = deg_to_rad(shootAngle)
	var angle: float = -shootAngleRad
	
	# Pre-calculations to prevent godot from calculating every loop
	var angleStep: float = 2*shootAngle / float(bulletsPerShot)
	var bulletStrength: float = float(STRENGTH) / float(bulletsPerShot)
	
	#spawn bullets
	while angle <= shootAngleRad:
		var newBullet: Node2D = bullet.instantiate()
		newBullet.rotation = angle
		newBullet.global_position = global_position + Vector2.from_angle(angle)
		newBullet.initialForce = bulletStrength
		
		add_child(newBullet)
		newBullet.shoot()
		
		angle += angleStep

func _input(event: InputEvent) -> void:
	if event.is_action("Fire"):
		shoot()

func _physics_process(_delta: float) -> void:
	var MousePos: Vector2 = get_global_mouse_position()
	look_at(MousePos)
