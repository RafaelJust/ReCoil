extends RigidBody2D

@export var invincible: bool = false

# Gun properties
@export var strength: int = 10000
@export var shootAngle: int = 20 #using degrees for convenience
@export var bulletsPerShot: int = 10
@export var bulletLifeTime: float = 2
@export var bulletDamage: float = 1

# Sound effects
@export var ShootSound: AudioStreamMP3
@export var ReloadSound: AudioStreamMP3


var Dead: bool = false

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
	
	# Play the shooting sound
	%ShootSound.play()

func _physics_process(_delta: float) -> void:
	if Dead: return
	
	#Change recitcle wideness based on angle
	
	# Aiming
	var MousePos: Vector2 = get_global_mouse_position()
	look_at(MousePos)
	
	# Only shoot when there are bullets in the chamber (usedShots < 2)
	if Input.is_action_just_pressed("Fire") && (usedShots < 2):
		usedShots += 1
		shoot()
		
		# Shake the screen, and start a cooldown (reload) timer
		get_node("/root/Main/Camera").shakeScreen(1,4)
		%Cooldown.start()
	
	if Input.is_action_just_pressed("Increase gun Angle"):
		shootAngle = min(shootAngle + 5, 60)
		bulletsPerShot = round(float(shootAngle) / 2)
		bulletLifeTime = min(float(60 - shootAngle) / 8,2)
		bulletDamage = bulletLifeTime / 2
		strength = bulletsPerShot * 1000
		
		changeRecticle(shootAngle)
	
	elif Input.is_action_just_pressed("Decrease gun angle"):
		shootAngle = max(shootAngle - 5, 5)
		bulletsPerShot = round(float(shootAngle) / 2)
		bulletLifeTime = min(float(60 - shootAngle) / 8,2)
		bulletDamage = bulletLifeTime / 2
		strength = bulletsPerShot * 1000
		
		changeRecticle(shootAngle)

func take_damage():
	if invincible: return
	
	get_node("/root/Main/Camera").shakeScreen(1.5,2)
	
	if $Invincibility.is_stopped():
		#Take damage
		lives -= 1
		if lives <= 0:
			# Die
			self.modulate = Color.BLACK
			Dead = true
			deathSignal.emit()
			self.collision_layer = 2
		else:
			$Invincibility.start()
			$AnimationPlayer.play("flicker")
		
		# Change Lives amount
		get_tree().get_root().get_node("/root/Main/UI/Hud").show_lives(lives)

func Reload() -> void: # Timer runs out -> reload
	if (usedShots > 0):
		usedShots -= 1
		%Cooldown.start()
		
		#Play the sound 
		%ReloadSound.play()


func _on_invincibility_timeout() -> void:
	$AnimationPlayer.play("RESET") # Stop the flickering


func _on_body_entered(body: Node) -> void:
	if body.get_collision_layer_value(5) == true:
		take_damage()

func _input(event):
	if event.is_action("die"):
		lives = 1
		take_damage()

func changeRecticle(newAngle: float):
	var angleRad = deg_to_rad(newAngle) # Godot uses radians, so it needs to be converted first
	
	# Using tan(angle) = (hor/2)/4490 we can determine the needed horizontal width of the recticle
	var newWidth = tan(angleRad) * 4490
	# Convert the width from pixels to be relative to the default 1588 px
	var newWidthRelative = newWidth / 1588 
	
	$Recitcle.scale = Vector2(newWidthRelative,1)
	$Recitcle.visible = true
	
	get_node("/root/Main").times_angle_changed += 1
	
	#%ShootSound.pitch_scale = 20 - newAngle
