extends Node2D

var isOnBreak: bool = false
var dead: bool = false

const WALLS: Array = ["D","U","L","R"]
const LOCATIONS: Array = [Vector2(0,360),Vector2(0,-360),Vector2(-600,0),Vector2(600,0)]

var difficulty: float = 0

@export var wave: int = 0

signal WaveStart

func _ready() -> void:
	while not dead:
		await %GameLoopTimer.timeout # using a timer as to not let it run every frame and use lots of memory
		if not isOnBreak: # Don't spawn enemies if on break (i.e. showing scores) THIS IS NOT IMPLEMENTED YET
			if $Enemies.get_child_count() > 0 || $Walls.CheckOpen(): continue
			
			if dead: break # Just to make sure no object spawn AFTER death
			
			if randi_range(1,20) == 1: #Have a random chance to spawn something else than enemies
				spawnMisc()
			else:
				WaveStart.emit()
				spawnEnemies(randi_range(1, max(1, floor(wave * 0.2))))
				wave += 1

func spawnEnemies(amount: int) -> void:
	get_node("UI/Hud").show_wave(wave)
	var wallQueue: Array = []# The walls to open after spawning the enemies
	for i in range(amount):
		var spawnNumber: int = randi_range(0,3) # 0 = down, 1 = up, 2 = Left, 3 = right
		
		var enemy: Node2D
		
		if randi_range(1,5) == 1:
			enemy = preload("res://Objects/Controlled/enemy_shooting.tscn").instantiate()
		else:
			enemy = preload("res://Objects/Controlled/enemy.tscn").instantiate() #Create enemy
		
		#Get spawn location from array, and add corresponding wall to the queue
		enemy.position = LOCATIONS[spawnNumber]
		wallQueue.append(WALLS[spawnNumber])
		
		$Enemies.add_child(enemy) # Place the enemy in the world
	
	$Walls.OpenWalls(wallQueue) # Open the required walls for enemies to come in
	
	
func _input(event: InputEvent) -> void:
	#quit the game
	if event.is_action("quit") && !dead:
		%Player.deathSignal.emit()
		#get_tree().quit()

func spawnMisc() -> void:
	spawnBox() # There are only boxes now, so no need for randomness here.

# Spawns a box to the map
func spawnBox() -> void:
	var spawnNumber: int = randi_range(0,3)
	var box: Node2D = preload("res://Objects/moving_box.tscn").instantiate()
	
	box.position = LOCATIONS[spawnNumber]
	
	$Walls.OpenWalls([WALLS[spawnNumber]])
	await get_tree().create_timer(0.5).timeout # Wait half a second for the doors to open
	# Spawn in the box, and move it out of the spawn room
	$Objects.add_child(box)
	box.apply_central_force(-LOCATIONS[spawnNumber] * box.mass * 10)

# Unload scene on player death
func _on_player_death() -> void:
	dead = true
	# Here can come the animation for the signal n shit
	
	#Clear all nodes first, because collision objects can't be present when changing scene
	for n: Node in get_children():
		n.queue_free()
	await get_tree().process_frame
	get_tree().change_scene_to_packed(load("res://Scenes/Title.tscn"))
