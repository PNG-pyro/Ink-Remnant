extends Button

func _ready() -> void:
	if SaveManager.university_visible != true:
		visible = false
		
	SignalHub.appear_university.connect(_set_visible)
	SignalHub.resource_updated.connect(_make_visible)


func _on_pressed() -> void:
	SceneManager.set_scene(SceneManager.Scene.UNIVERSITY)


func _make_visible(_a = null, _b = null):
		visible = SaveManager.university_visible


func _set_visible():
	SaveManager.university_visible = true
	visible = SaveManager.university_visible
