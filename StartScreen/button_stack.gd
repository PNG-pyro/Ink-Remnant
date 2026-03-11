extends VBoxContainer
class_name ButtonStack

#@export var my_theme: Theme = load("res://tween_theme.tres")


func _ready():
	self.visible = false
	SignalHub.make_visible.connect(make_visible)
	SignalHub.hometoggle.connect(set_vis)


func populate(job_batch: Array[Job]):
	for child in get_children():
		child.free()
	for job in job_batch:
		var new_button = BarButton.new()
		new_button.set_job(job)
		new_button.add_to_group("BarButtons")
		new_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		#new_button.theme = my_theme
		add_child(new_button)


func make_visible():
	self.visible = true


func set_vis(toggle: bool):
	self.visible = toggle
