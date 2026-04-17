extends Button

var button_name = "Market"


func _ready() -> void:
	if SaveManager.visible_buttons.has(button_name):
		visible = SaveManager.visible_buttons[button_name]
	else:
		visible = false
	
	SignalHub.appear_market.connect(_set_visible)
	SignalHub.resource_updated.connect(_make_visible)


func _on_pressed() -> void:
	SceneManager.set_scene(SceneManager.Scene.MARKET)
	SignalHub.disappear_streets.emit()
	SignalHub.disappear_people.emit()


func _make_visible(_a = null, _b = null):
	if SaveManager.visible_buttons.has(button_name):
		visible = SaveManager.visible_buttons[button_name]


func _set_visible():
	SaveManager.visible_buttons[button_name] = true
	_make_visible()
	SaveManager.save(SaveManager.save_name_3)
