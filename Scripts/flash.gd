extends RichTextLabel

var fontsize: float = 30

@onready var mainobj: Node2D = get_node("/root/Main")

func _on_hud_update_score() -> void:
	fontsize += 10

func _process(delta: float) -> void:
	if fontsize <= 30:
		pass
	else:
		self.text = "[right][font_size=" + str(fontsize) + "]" + str(mainobj.score)
		fontsize -= delta * 10
