extends Button

func _on_pressed() -> void:
	SaveManager.load(SaveManager.save_name_1)
