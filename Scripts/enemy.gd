extends RigidBody2D

@export var force: int = 1000
@export var lives: int = 5

var player: Node2D

func _ready() -> void:
	#setup for collision detection with rigidbodies
	contact_monitor = true
	max_contacts_reported = 5
	
	player = get_node("/root/Main/Player")
	
	self.add_to_group("Enemies")

func  _physics_process(_delta: float) -> void:
	# Make a Vector2 that points into the direction of the player
	var dir: Vector2 = (player.global_position - self.global_position).normalized()
	
	#Apply force into that direction
	apply_central_force(dir * force)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Bullets"):
		body.queue_free() #remove the hit bullet
		lives -= 1
		if lives <= 0:
			queue_free()
