extends RigidBody2D

@export var force: int = 1000
@export var lives: int = 7
@export var value: int = 10 #The mount added to the score after being defeated.

@export var canBoost: bool
@export var canHurt: bool
@export var disabled: bool

@export var followPlayer: bool = true
@export var canShoot = false
var currentGoal: Vector2 = Vector2(0,0)

var player: Node2D

var boostAmount = 50

func _ready() -> void:
	if disabled: return
	#setup for collision detection with rigidbodies
	contact_monitor = true
	max_contacts_reported = 5
	
	player = get_node("/root/Main/Player")
	player.deathSignal.connect(_despawn)
	
	if !followPlayer:
		$PathTimer.start()
		change_path()

func  _physics_process(_delta: float) -> void:
	if disabled: return
	if followPlayer:
		# Make a Vector2 that points into the direction of the player
		var dir: Vector2 = (player.global_position - self.global_position).normalized()
	
		#Apply force into that direction
		apply_central_force(dir * force)
	else:
		var dir: Vector2 = (currentGoal - self.global_position).normalized()
		if canBoost and boostAmount > 0:
			apply_central_force(dir * boostAmount * force)
			boostAmount -= 1
		apply_central_force(dir * force)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Bullets"):
		lives -= 1
		$AnimationPlayer.play("flicker")
		body.queue_free() #remove the hit bullet

		if lives == 0:
			get_node("/root/Main").kills += 1
			get_node("/root/Main").add_score(value)
			get_node("/root/Main").combo_add();
			queue_free()
	elif body.name == "Player":
		#move away from the player
		apply_central_force((player.global_position - self.global_position).normalized() * -50000)

func shoot_enemy_bullet() -> void:
	var bullet: Node2D = preload("res://Objects/bullet_enemy.tscn").instantiate()
	bullet.position = global_position
	bullet.look_at(player.position)
	get_node("/root/Main").add_child(bullet)
	bullet.shoot(500, 2)


func change_path() -> void:
	var path: PathFollow2D = get_node("/root/Main/EnemyGoals/enemyPath")
	path.progress_ratio = randf()
	currentGoal = path.global_position

func _despawn():
	queue_free()
