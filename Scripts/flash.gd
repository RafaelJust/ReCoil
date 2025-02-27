extends RichTextLabel

var fontsize: int = 50

func _on_hud_update_score() -> void:
	self.add_theme_font_size_override("Normal Font Size", fontsize + 10)

func _process(delta: float) -> void:
	if fontsize <= 50:
		fontsize = 50
	else:
		self.add_theme_font_size_override("Normal Font Size",)
