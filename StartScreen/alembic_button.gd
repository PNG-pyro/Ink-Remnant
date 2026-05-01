extends Button

var button_name = "Alembic"


func _ready() -> void:
	if SaveManager.visible_buttons.has(button_name):
		visible = SaveManager.visible_buttons[button_name]
	else:
		visible = false
	
	SignalHub.appear_alembic.connect(_set_visible)
	SignalHub.resource_updated.connect(_make_visible)


func _on_pressed() -> void:
	SceneManager.set_scene(SceneManager.Scene.ALEMBIC)


func _make_visible(_a = null, _b = null):
	if SaveManager.visible_buttons.has(button_name):
		visible = SaveManager.visible_buttons[button_name]


func _set_visible():
	SaveManager.visible_buttons[button_name] = true
	_make_visible()
	SaveManager.save(SaveManager.save_name_3)
