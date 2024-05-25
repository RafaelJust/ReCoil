extends Node2D

#Simple function to redirect animation commands to the correct players
func OpenWalls(walls: Array) -> void:
	if "D" in walls:
		$Wall_D/Open.play("Open")
	if "U" in walls:
		$Wall_U/Open.play("Open")
	if "L" in walls:
		$Wall_L/Open.play("Open")
	if "R" in walls:
		$Wall_R/Open.play("Open")

# Check if a door is still open / animation is still playing
func CheckOpen() -> bool:
	var result: bool = false
	for wall: Node2D in get_children():
		if wall.get_node("Open").is_playing():
			result = true
	return result
