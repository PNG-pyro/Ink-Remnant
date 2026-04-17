extends Button


func _on_pressed() -> void:
	SignalHub.set_theme_dark.emit()
	SignalHub.resource_updated.emit(CurrencyManager.get_currency("Default Currency"), 0)
