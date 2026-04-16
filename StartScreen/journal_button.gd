extends Button

#var dialogue = load("res://Currencies/journal.dialogue")
func _pressed() -> void:
	#DialogueManager.show_dialogue_balloon(dialogue, "start")
	SceneManager.set_scene(SceneManager.Scene.JOURNAL)
