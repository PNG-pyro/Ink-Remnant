extends HSlider

func _ready() -> void:
	SignalHub.volume_set.connect(set_vol)


func set_vol(volume: float, _mute: bool):
	self.value = volume


func _on_value_changed(new_value: float) -> void:
	BackgroundMusicPlayer.volume_linear = new_value
	SaveManager.save(SaveManager.save_name_3)
