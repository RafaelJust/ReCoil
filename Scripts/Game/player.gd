extends RigidBody2D



# Gun properties
@export var strength: int = 10000
@export var shootAngle: int = 20 #using degrees for convenience
@export var bulletsPerShot: int = 10
@export var bulletLifeTime: float = 2
@export var bulletDamage: float = 1

var usedShots: int = 0 # / 2

var bullet: PackedScene

var lives: int = 3

signal deathSignal

func _ready() -> void:
	bullet = preload("res://Objects/bullet.tscn")

func shoot() -> void:
	# Get the current rotation, and apply force to the opposite way.
	var dir: Vector2 = Vector2.from_angle(rotation)
	apply_central_force(dir * -strength) # Make the force negative to simulate recoil
	
	var shootAngleRad: float = deg_to_rad(shootAngle)
	var angle: float = rotation - shootAngleRad
	
	# Pre-calculations to prevent godot from calculating every loop
	var angleStep: float = 2*shootAngleRad / float(bulletsPerShot) # How many radians each bullet offsets
	var bulletstrength: float = float(strength) / float(bulletsPerShot) #how much force each bullet shoots
	var angleGoal: float = rotation + shootAngleRad # The end goal of the shot
	
	#spawn bullets
	while angle <= angleGoal:
		
		var newBullet: Node2D = bullet.instantiate()
		
		# Set the angle and position of the bullet to the player
		newBullet.rotation = angle
		# move the bullet a little bit to the front
		newBullet.global_position = global_position + Vector2.from_angle(angle)
		
		#finally spawn in the bulleta
		add_child(newBullet)
		newBullet.shoot(bulletstrength, bulletLifeTime, bulletDamage)
		
		angle += angleStep

func _physics_process(_delta: float) -> void:
	
	# Aiming
	var MousePos: Vector2 = get_global_mouse_position()
	look_at(MousePos)
	
	# Only shoot when there are bullets in the chamber (usedShots < 2)
	if Input.is_action_just_pressed("Fire") && (usedShots < 2):
		usedShots += 1
		shoot()
		# Shake the screen, and start a cooldown (reload) timer
		get_node("/root/Main/Camera").shakeScreen(1,2)
		%Cooldown.start()

func take_damage():
	if $Invincibility.is_stopped():
		#Take damage
		lives -= 1
		if lives <= 0:
			# Die
			deathSignal.emit()
		else:
			$Invincibility.start()
			$AnimationPlayer.play("flicker")
		
			# Change Lives amount
			get_tree().get_root().get_node("/root/Main/UI/Hud").show_lives(lives)

func Reload() -> void: # Timer runs out -> reload
	if (usedShots > 0):
		usedShots -= 1
		%Cooldown.start()


func _on_invincibility_timeout() -> void:
	$AnimationPlayer.play("RESET") # Stop the flickering


func _on_body_entered(body: Node) -> void:
	if body.get_collision_layer_value(5) == true:
		take_damage()
