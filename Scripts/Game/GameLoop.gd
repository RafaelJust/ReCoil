extends Node2D

var isOnBreak: bool = false
var dead: bool = false

const WALLS: Array = ["D","U","L","R"]
const LOCATIONS: Array = [Vector2(0,360),Vector2(0,-360),Vector2(-600,0),Vector2(600,0)]

var difficulty: float = 0

@export var wave: int = 0

var musicprogs: int = 0

# Boxes and powerups block other items and enemies
var blocked: Array

signal WaveStart


# Game stats that are tracked during playtime
var kills: int = 0
var times_angle_changed: int = 0
var score: int = 0

#This variable tracks if player is using a gamepad or mouse + keyboard
var gamepad: bool = false

# Function from hiulit and RedWanFox
func get_all_files(path: String, file_ext := "", files := []):
	var dir = DirAccess.open(path)
	
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()

		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				files = get_all_files(dir.get_current_dir() +"/"+ file_name, file_ext, files)
			else:
				if file_ext and file_name.get_extension() != file_ext:
					file_name = dir.get_next()
					continue
				
				files.append(dir.get_current_dir() +"/"+ file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)

	return files


func _ready() -> void:
	#Scroll through the tutorial text
	for i in range(2):
		await $GameLoopTimerHalf.timeout
		%Hud.changeTutorialText()
	
	# The music take two beats to start, so tell it already to start here
	$Music.Lead = 1
	
	#Scroll through the tutorial text
	for i in range(2):
		await $GameLoopTimerHalf.timeout
		%Hud.changeTutorialText()
	
	# Remove teh temporary timer as it has done it's purpose, and call the
	# Hud function again to remove the tutorial text
	$GameLoopTimerHalf.queue_free()
	%Hud.changeTutorialText()
	while not dead:
		if not isOnBreak: # Don't spawn enemies if on break (i.e. showing scores) THIS IS NOT IMPLEMENTED YET
			if $Walls.CheckOpen(): continue
			
			if dead: break # Just to make sure no object spawn AFTER death
			
			if randi_range(1,3) == 1: #Have a random chance to spawn something else than enemies
				spawnMisc()
			WaveStart.emit()
			spawnEnemies(randi_range(1, max(1, floor(wave * 0.2))))
			wave += 1
			if wave % 4 ==0:
				UpdateMusic()
		await %GameLoopTimer.timeout # using a timer as to not let it run every frame and use lots of memory

func UpdateMusic():
	musicprogs += 1
	var rnd: int
	if musicprogs >= 4: rnd = randi_range(1,8)
	else: rnd = randi_range(1,3)
	
	if rnd == 1: $Music.Drums = $Music.Drums + 1
	elif rnd == 2: $Music.Bass = $Music.Bass + 1
	elif rnd == 3: $Music.Lead = $Music.Lead + 1
	else:
		$Music.Other[rnd - 4] = not $Music.Other[rnd - 4]

func spawnEnemies(amount: int) -> void:
	var wallQueue: Array = []# The walls to open after spawning the enemies
	for i in range(amount):
		var spawnNumber: int
		while true: # There is no do while loop, so this is a hacky way of achieving the same effect
			spawnNumber = randi_range(0,3)
			if not (spawnNumber in blocked):
				break
		
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
	
	blocked.clear() #clear the blocked array
	
	
func _input(event: InputEvent) -> void:
	#pause / end the game
	if event.is_action("quit"):
		if !dead: pause_game()
		else: $UI/Hud/GameOverAnim.play("Out")

func spawnMisc() -> void:
	# make new gun types rarer than boxes
	if false: #randi_range(1,2) == 1:
		spawnItem()

	else:
		spawnBox()

# Spawns a box to the map
func spawnBox() -> void:
	var box: Node2D = preload("res://Objects/moving_box.tscn").instantiate()
	spawnObject(box)
	
func spawnObject(obj: Node2D):
	var spawnNumber: int
	while true: # There is no do while loop, so this is a hacky way of achieving the same effect
		spawnNumber = randi_range(0,3)
		if not (spawnNumber in blocked):
			break
	obj.position = LOCATIONS[spawnNumber]
	
	blocked.append(spawnNumber)
	
	$Walls.OpenWalls([WALLS[spawnNumber]])
	await get_tree().create_timer(0.5).timeout # Wait half a second for the doors to open
	# Spawn in the object, and move it out of the spawn room
	$Objects.add_child(obj)
	obj.apply_central_force(-LOCATIONS[spawnNumber] * obj.mass * 10)

# Unload scene on player death
func _on_player_death() -> void:
	if dead: return
	dead = true
	get_node("Music").stopMusic()
	
	%GameLoopTimer.queue_free() #prevent the timer activating further scripts
	
	# store the path so it is easier to change all the values
	var stats: Node = $UI/Hud/GameOver/Stats
	# Update the game over text so the correct values are shown
	stats.get_node("WaveValue").text = str(wave)
	stats.get_node("KillsValue").text = str(kills)
	stats.get_node("AngleValue").text = str(times_angle_changed)
	stats.get_node("ScoreValue").text = str(score)
	# Here can come the animation for the signal n shit
	$UI/Hud/GameOverAnim.play("GameOver")


func spawnItem():
	#Get a randon scene from the "Upgrades" directory, and load it.
	var allFiles: Array = get_all_files("res://Upgrades/", "tscn")
	var chosenUpgrade: String = allFiles.pick_random()
	var upgrade: Node2D = load(chosenUpgrade).instantiate()
	
	# Spawn in the Item
	spawnObject(upgrade)

func pause_game():
	isOnBreak = true
	%"Pause menu".visible = true
	get_tree().paused = true

# Resume the game after pausing
func continue_game():
	get_tree().paused = false
	isOnBreak = false

# Adds the score and immediately calls a function to display the change.
func add_score(amount: int):
	score += amount
	%Hud.show_score(score)

func _on_game_loop_timer_timeout():
	add_score(15)
