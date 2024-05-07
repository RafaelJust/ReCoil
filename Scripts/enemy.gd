extends RigidBody2D

@export var force: int = 1000
@export var lives: int = 5

@export var followPlayer: bool = true
var currentGoal: Vector2 = Vector2(0,0)

var player: Node2D

func _ready() -> void:
	#setup for collision detection with rigidbodies
	contact_monitor = true
	max_contacts_reported = 5
	
	player = get_node("/root/Main/Player")

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
		body.queue_free() #remove the hit bullet
		lives -= 1
		if lives <= 0:
			queue_free()
	if body == player && $shootTimer == null:
		# Tell the player to take damage
		body.take_damage()
		
		#move away from the player
		apply_central_force((player.global_position - self.global_position).normalized() * -50000)


func shoot_enemy_bullet() -> void:
	var bullet: Node2D = preload("res://Objects/bullet_enemy.tscn").instantiate()
	bullet.position = global_position
	bullet.look_at(player.position)
	add_child(bullet)
	bullet.shoot()


func change_path() -> void:
	var path: PathFollow2D = get_node("/root/Main/EnemyGoals/enemyPath")
	path.progress_ratio = randf()
	currentGoal = path.global_position
