extends RigidBody2D

@export var rangeX: Vector2 = Vector2(10,100)
@export var rangeY: Vector2 = Vector2(10,100)

func _ready() -> void:
	# Generate random sizes
	var sizeX: float = randf_range(rangeX.x, rangeX.y)
	var sizeY: float = randf_range(rangeY.x, rangeY.y)
	var newSize: Vector2 = Vector2(sizeX, sizeY)
	# Apply random sizes
	$Collision.scale = newSize
	$Texture.size = newSize * 20
	self.mass = (sizeX * sizeY) * 0.1
