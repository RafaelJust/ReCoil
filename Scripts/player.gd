extends RigidBody2D

const STRENGTH: int = 10000
var shootAngle: int = 20 #using degrees for convenience
var bulletsPerShot: int = 10

var usedShots: int = 0 # / 2

var bullet: PackedScene

var lives: int = 3

func _ready() -> void:
	bullet = preload("res://Objects/bullet.tscn")

func shoot() -> void:
	# Get the current rotation, and apply force to the opposite way.
	var dir: Vector2 = Vector2.from_angle(rotation)
	apply_central_force(dir * -STRENGTH) # Make the force negative to simulate recoil
	
	var shootAngleRad: float = deg_to_rad(shootAngle)
	var angle: float = rotation - shootAngleRad
	
	# Pre-calculations to prevent godot from calculating every loop
	var angleStep: float = 2*shootAngleRad / float(bulletsPerShot) # How many radians each bullet offsets
	var bulletStrength: float = float(STRENGTH) / float(bulletsPerShot) #how much force each bullet shoots
	var angleGoal: float = rotation + shootAngleRad # The end goal of the shot
	
	#spawn bullets
	while angle <= angleGoal:
		var newBullet: Node2D = bullet.instantiate()
		newBullet.rotation = angle
		newBullet.global_position = global_position + Vector2.from_angle(angle)
		newBullet.initialForce = bulletStrength
		
		add_child(newBullet)
		newBullet.shoot()
		
		angle += angleStep

func _physics_process(_delta: float) -> void:
	
	# Aiming
	var MousePos: Vector2 = get_global_mouse_position()
	look_at(MousePos)
	
	if Input.is_action_just_pressed("Fire") && (usedShots < 2):
		usedShots += 1
		shoot()
		get_node("/root/Main/Camera").shakeScreen(1,2)
		%Cooldown.start()

func take_damage():
	if $Invincibility.is_stopped():
		#Take damage
		lives -= 1
		if lives <= 0:
			# Die
			get_tree().quit()
		else:
			$Invincibility.start()
			$AnimationPlayer.play("flicker")
			get_node("/root/Main/Camera").shakeScreen(2,3)
		
		# Change Lives amount
		get_tree().get_root().get_node("/root/Main/UI/Hud").show_lives(lives)

func Reload() -> void: # Timer runs out -> reload
	if (usedShots > 0):
		usedShots -= 1
		%Cooldown.start()


func _on_invincibility_timeout() -> void:
	$AnimationPlayer.play("RESET") # Stop the flickering
