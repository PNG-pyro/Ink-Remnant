extends CheckButton

func _ready() -> void:
	SignalHub.volume_set.connect(set_mute)


func _on_toggled(toggled_on: bool) -> void:
	BackgroundMusicPlayer.stream_paused = toggled_on
	SaveManager.save(SaveManager.save_name_3)



func set_mute(_volume: float, mute: bool):
	self.button_pressed = mute
