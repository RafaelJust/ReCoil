extends Control
@export var volumeCurve: Curve
var crt_on: bool = true
var crt_shader: Control

func _ready() -> void:
	
	# find current scene
	if get_node_or_null("/root/Main") == null:
		# title screen
		crt_shader = get_node("/root/Title/SceneTransition/CRT shader")
	else:
		crt_shader = get_node("/root/Main/UI/SceneTransition/CRT shader")
	
	var file = FileAccess.open("user://options.dat", FileAccess.READ)
	if not file:
		return
	
	# Set sliders to correct values
	%MasterVolumeSlider.value = file.get_8()
	%MusicVolumeSlider.value = file.get_8()
	%SfxVolumeSlider.value = file.get_8()
	crt_on = file.get_var()
	
	crt_shader.visible = crt_on
	%crtButton.button_pressed = crt_on
	
	$"Save Interval".start()

func _on_master_volume_slider_value_changed(value):
	%ValueMaster.text = str(round(value))
	AudioServer.set_bus_volume_db(0, volumeCurve.sample(value / 100))
	if $"Save Interval".is_stopped():
		$"Save Interval".start()

func _on_music_volume_slider_value_changed(value):
	%ValueMusic.text = str(round(value))
	AudioServer.set_bus_volume_db(1, volumeCurve.sample(value / 100))
	if $"Save Interval".is_stopped():
		$"Save Interval".start()


func _on_sfx_volume_slider_value_changed(value):
	%ValueSfx.text = str(round(value))
	AudioServer.set_bus_volume_db(2, volumeCurve.sample(value / 100))
	if %SFXTimer.time_left == 0:
		%sfxSlider.play()
		%SFXTimer.start()
	if $"Save Interval".is_stopped():
		$"Save Interval".start()


func _on_save_interval_timeout() -> void:
	# Write options to file
	var file = FileAccess.open("user://options.dat", FileAccess.WRITE)
	if not file:
		printerr("Cannot open options file for writing!")
		return

	file.store_8(%MasterVolumeSlider.value) # Master
	file.store_8(%MusicVolumeSlider.value) # Music
	file.store_8(%SfxVolumeSlider.value) # SFX
	file.store_var(crt_on)
	
	if get_tree().paused:
		$"Save Interval".start()


func _on_crt_shader_toggled(toggled_on: bool) -> void:
	crt_shader.visible = toggled_on
	crt_on = toggled_on


func _on_back_button_pressed() -> void:
	_on_save_interval_timeout()
	get_node("/root/Title/AnimationPlayer").play("wipe_to_main")
