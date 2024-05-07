extends Node2D

var isOnBreak: bool = false
var dead: bool = false

const WALLS: Array = ["D","U","L","R"]
const LOCATIONS: Array = [Vector2(0,360),Vector2(0,-360),Vector2(-600,0),Vector2(600,0)]

var difficulty: float = 0

func _ready() -> void:
	while not dead:
		if not isOnBreak: # Don't spawn enemies if on break (i.e. showing scores)
			await get_tree().create_timer(randf_range(3,10)).timeout
			if randi_range(1,5) == 1: #Have a random chance to spawn something else than enemies
				spawnMisc()
			else:
				spawnEnemies(randi_range(1,4))

func spawnEnemies(amount: int) -> void:
	var wallQueue: Array = []# The walls to open after spawning the enemies
	for i in range(amount):
		var spawnNumber: int = randi_range(0,3) # 0 = down, 1 = up, 2 = Left, 3 = right
		
		var enemy: Node2D
		
		if randi_range(1,5) == 1:
			enemy = preload("res://Objects/enemy_shooting.tscn").instantiate()
		else:
			enemy = preload("res://Objects/enemy.tscn").instantiate() #Create enemy
		
		#Get spawn location from array, and add corresponding wall to the queue
		enemy.position = LOCATIONS[spawnNumber]
		wallQueue.append(WALLS[spawnNumber])
		
		$Objects.add_child(enemy) # Place the enemy in the world
	
	$Walls.OpenWalls(wallQueue) # Open the required walls for enemies to come in
	
	
func _input(event: InputEvent) -> void:
	#quit the game
	if event.is_action("quit"):
		get_tree().quit()

func spawnMisc() -> void:
	spawnBox() # There are only boxes now, so no need for randomness here.

func spawnBox() -> void:
	var spawnNumber: int = randi_range(0,3)
	var box: Node2D = preload("res://Objects/moving_box.tscn").instantiate()
	
	box.position = LOCATIONS[spawnNumber]
	
	$Walls.OpenWalls([WALLS[spawnNumber]])
	await get_tree().create_timer(0.5).timeout # Wait half a second for the doors to open
	# Spawn in the box, and move it out of the spawn room
	$Objects.add_child(box)
	box.apply_central_force(-LOCATIONS[spawnNumber] * box.mass * 10)
