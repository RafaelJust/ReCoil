extends RigidBody2D

@export var force: int = 1000
@export var lives: int = 5
@export var value: int = 10 #The mount added to the score after being defeated.

@export var followPlayer: bool = true
@export var canShoot = false
var currentGoal: Vector2 = Vector2(0,0)

var player: Node2D

func _ready() -> void:
	#setup for collision detection with rigidbodies
	contact_monitor = true
	max_contacts_reported = 5
	
	player = get_node("/root/Main/Player")
	player.deathSignal.connect(_despawn)

func  _physics_process(_delta: float) -> void:
	if followPlayer:
		# Make a Vector2 that points into the direction of the player
		var dir: Vector2 = (player.global_position - self.global_position).normalized()
	
		#Apply force into that direction
		apply_central_force(dir * force)
	else:
		var dir: Vector2 = (currentGoal - self.global_position).normalized()
		apply_central_force(dir * force)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Bullets"):
		lives -= body.damage # Take the amount of damage
		$AnimationPlayer.play("flicker")
		body.queue_free() #remove the hit bullet
		if lives <= 0:
			get_node("/root/Main").kills += 1
			get_node("/root/Main").score += value
			queue_free()
	if body == player && !canShoot:
		#move away from the player
		apply_central_force((player.global_position - self.global_position).normalized() * -50000)


func shoot_enemy_bullet() -> void:
	var bullet: Node2D = preload("res://Objects/bullet_enemy.tscn").instantiate()
	bullet.position = global_position
	bullet.look_at(player.position)
	add_child(bullet)
	bullet.shoot(500, 2, 1)


func change_path() -> void:
	var path: PathFollow2D = get_node("/root/Main/EnemyGoals/enemyPath")
	path.progress_ratio = randf()
	currentGoal = path.global_position

func _despawn():
	queue_free()
