extends Control
@export var volumeCurve: Curve

func _ready() -> void:
	
	var file = FileAccess.open("user://options.dat", FileAccess.READ)
	if not file:
		return
	
	# Set sliders to correct values
	%MasterVolumeSlider.value = file.get_8()
	%MusicVolumeSlider.value = file.get_8()
	%SfxVolumeSlider.value = file.get_8()
	
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
	
	if get_tree().paused:
		$"Save Interval".start()
