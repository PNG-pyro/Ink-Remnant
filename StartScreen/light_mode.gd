extends Button


func _on_pressed() -> void:
	SignalHub.set_theme_light.emit()
