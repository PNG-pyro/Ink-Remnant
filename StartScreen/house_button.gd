extends Button

var toggle: bool = false

func _ready() -> void:
	SignalHub.second_popup_closed.connect(make_visible)


func make_visible():
	self.visible = true


func _on_pressed() -> void:
		SceneManager.set_scene(SceneManager.Scene.HOUSE)

	
