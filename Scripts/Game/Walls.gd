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
