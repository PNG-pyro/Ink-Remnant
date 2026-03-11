extends CheckButton
class_name BarButton

# Define your states
enum State {
	IDLE,
	FILLING,
	COMPLETE
}

# Current state variable
var current_state = State.IDLE

@export var job_run: Job

@onready var startrun: bool = true
@onready var progress = ProgressBar.new()
@onready var parent = $".."

func _ready():
	visible = job_run.is_unmasked()
	text = job_run.job_name
	toggle_mode = true
	progress.set_anchors_preset(Control.PRESET_FULL_RECT)
	progress.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#progress.offset_left = 5
	#progress.offset_right = -5
	#progress.offset_top = 5
	#progress.offset_bottom = -5
	progress.show_percentage = false
	progress.value = 0
	update_tooltip()
	add_child(progress)
	pressed.connect(_on_pressed)
	SignalHub.resource_updated.connect(check_visible)
	SignalHub.resource_updated.connect(func(_a, _b): update_tooltip())
	#SignalHub.resource_upgraded.connect(check_visible)


func _on_pressed():
	match current_state:
		State.IDLE:
			startrun = true
			start_filling()
		State.FILLING:
			return
		State.COMPLETE:
			reset()


func start_filling():
	if not job_run.can_afford():
		reset()
		return
	if not job_run.has_room():
		reset()
		return
	if job_run.check_upper_mask():
		reset()
		return
	if startrun == true:
		SignalHub.display.emit(job_run.job_desc + "\n")
		startrun = false
	
	current_state = State.FILLING
	progress.value = 0
	get_tree().call_group("BarButtons", "disable_others", self)
	
	var tween = create_tween()
	tween.tween_property(progress, "value", 100, job_run.job_duration)
	await tween.finished
	
	job_run.pay_reward()
	job_run.pay_costs()
	
	if self.button_pressed == true:
		start_filling()
		SignalHub.job_complete.emit(job_run)
	if self.button_pressed == false:
		SignalHub.display.emit(job_run.job_story + "\n\n")
		SignalHub.job_complete.emit(job_run)
		current_state = State.COMPLETE
		reset()


func reset():
	current_state = State.IDLE
	get_tree().call_group("BarButtons", "enable_self")
	self.button_pressed = false
	progress.value = 0


func set_job(job_to_set: Job):
	job_run = job_to_set


func check_visible(_resource, _amount):
	if job_run.is_unmasked():
		job_run.shows_up = true
	if job_run.check_upper_mask():
		job_run.shows_up = false
	visible = job_run.shows_up


func update_tooltip():
	var line: String = "Required:\n"
	for price in job_run.job_cost:
		if price.is_affordable(job_run.job_cost[price]):
			line += " [color=pale_green]" + str(job_run.job_cost[price]) + " " + price.name + ",[/color]\n"
		else: 
			line += " [color=tomato]" + str(job_run.job_cost[price]) + " " + price.name + ",[/color]\n"
	if job_run.make_tooltip == true:
		for price in job_run.upper_mask:
			line += "Max: " + str(price.amount) + "/" + str(price.max_amount)
	for price in job_run.job_reward:
		if price.name == "Floor Space":
			line += "\n" + "Floor Space: " + str(job_run.job_reward[price]) # + "/" + str(price.max_amount)
	tooltip_text = line
	
func disable_others(button: BarButton):
	if button != self:
		disabled = true

func enable_self():
	disabled = false

func _make_custom_tooltip(for_text):
	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.text = for_text
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.fit_content = true
	return label
