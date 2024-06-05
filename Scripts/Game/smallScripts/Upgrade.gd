extends RigidBody2D

# New gun overrides
@export var newStrength: int = 10000
@export var newShootAngle: int = 20 #using degrees for convenience
@export var newBulletsPerShot: int = 10
@export var newBulletLifeTime: float = 2
@export var newBulletDamage: float = 1


func Collect(player:RigidBody2D):
	# The player is the only one able to interact with this ared mesh, so it is definitely the player
	
	# Apply new gun rules
	player.strength = newStrength
	player.shootAngle = newShootAngle
	player.bulletsPerShot = newBulletsPerShot
	player.bulletLifeTime = newBulletLifeTime
	player.bulletDamage = newBulletDamage
	
	player.changeRecticle(newShootAngle) # tell the player to change it's recticle
	
	# Remove the upgrade
	queue_free()
