extends RigidBody2D

@export var rangeX: Vector2 = Vector2(10,100)
@export var rangeY: Vector2 = Vector2(10,100)

# How many waves the object persists
@onready var WaveLength: int = randi_range(5,20)
var age: int = 0

func newWave():
	age += 1
	if age >= WaveLength:
		queue_free()

func _ready() -> void:
	
	# Connect signal from gameloop to newWave function
	var gameLoop: Node2D = get_node("/root/Main")
	gameLoop.connect("WaveStart", newWave)
	
	# Generate random sizes
	var sizeX: float = randf_range(rangeX.x, rangeX.y)
	var sizeY: float = randf_range(rangeY.x, rangeY.y)
	var newSize: Vector2 = Vector2(sizeX, sizeY)
	# Apply random sizes
	$Collision.scale = newSize
	$Texture.size = newSize * 20
	$LightOccluder2D.scale = newSize
	self.mass = (sizeX * sizeY) * 0.1
