extends Sprite2D

func flash():
	self.position = get_parent().position #Make sure the sprite is aligned, since it doesn't move with the parent
	$AnimationPlayer.play("flash")
