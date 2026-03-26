extends Button
class_name BarButton

# Define your states
enum State {
	IDLE,
	FILLING,
	COMPLETE
}

enum VisualState {
	NORMAL      = 0,
	HOVERED     = 1,
	DISABLED    = 2,
	UNAFFORDABLE = 4,
	AFFORDABLE = 8,
	RUNNING = 16,
	NEW = 32,
}

var visual_state: int = VisualState.NORMAL
var current_state = State.IDLE

@export var job_run: Job
@export var story_box: RichTextLabel

@onready var startrun: bool = true
@onready var progress: ProgressBar = ProgressBar.new()
@onready var border: NinePatchRect = NinePatchRect.new()
@onready var ready_label: RichTextLabel = RichTextLabel.new()
@onready var new_label: RichTextLabel = RichTextLabel.new()
@onready var parent: Node = $".."
@onready var tween: Tween
@onready var tween_duration: float = 0.5


func _ready():
	visible = job_run.is_unmasked()
	text = job_run.job_name
	toggle_mode = true
	visual_state |= VisualState.NEW
	
	progress.set_anchors_preset(Control.PRESET_FULL_RECT)
	progress.mouse_filter = Control.MOUSE_FILTER_IGNORE
	progress.show_percentage = false
	progress.value = 0
	update_tooltip()
	add_child(progress)
	
	border.set_anchors_preset(Control.PRESET_FULL_RECT)
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#border.hide()
	border.texture = load("res://Borders/Currencies_Border.png")
	border.patch_margin_left = 16
	border.patch_margin_right = 16
	border.patch_margin_top = 16
	border.patch_margin_bottom = 16
	add_child(border)
	
	ready_label.bbcode_enabled = true
	ready_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	ready_label.fit_content = true
	ready_label.position = Vector2(10, 6)
	add_child(ready_label)
	
	new_label.bbcode_enabled = true
	new_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	new_label.fit_content = true
	new_label.position = Vector2(150, 6)
	add_child(new_label)
	
	visual_state |= VisualState.AFFORDABLE
	update_visuals()
	
	pressed.connect(_on_pressed)
	SignalHub.resource_updated.connect(check_visible)
	SignalHub.resource_updated.connect(func(_a, _b): update_tooltip())
	#SignalHub.resource_upgraded.connect(check_visible)
	mouse_entered.connect(on_mouse_entry)
	mouse_exited.connect(on_mouse_exit)
	SignalHub.resource_updated.connect(func(_a, _b):check_affordable())
	SignalHub.job_begun.connect(update_visuals)
	
	check_affordable()
	update_visuals()


func _on_pressed():
	match current_state:
		State.IDLE:
			startrun = true
			start_filling()
		State.FILLING:
			return
		State.COMPLETE:
			reset()

func on_mouse_entry():
	visual_state |= VisualState.HOVERED
	visual_state &= ~VisualState.NEW
	update_visuals()

func on_mouse_exit():
	visual_state &= ~VisualState.HOVERED
	update_visuals()

func update_visuals():
	
	if visual_state & VisualState.DISABLED:
		border.hide()
	elif visual_state & VisualState.RUNNING:
		border.show()
	elif visual_state & VisualState.HOVERED:
		border.show()
	else:
		border.hide()
	
	if visual_state & VisualState.NEW:
		self.text = job_run.job_name + " -New!"
	else:
		self.text = job_run.job_name
		
	if visual_state & VisualState.AFFORDABLE:
		ready_label.text = "[color=green]>[/color]"
	elif visual_state & VisualState.UNAFFORDABLE:
		ready_label.text = "[color=red]×[/color]"


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
		get_tree().call_group("BarButtons", "reset_others", self)
		SignalHub.display.emit(job_run.job_desc + "\n")
		startrun = false
	visual_state |= VisualState.RUNNING
	update_visuals()
	
	current_state = State.FILLING
	SignalHub.job_begun.emit()
	progress.value = 0
	
	tween = create_tween()
	tween_duration = calc_duration()
	tween.tween_property(progress, "value", 100, tween_duration)
	await tween.finished
	
	job_run.pay_reward()
	job_run.pay_costs()

	if not job_run.repeats:
		self.button_pressed = false

	if self.button_pressed == true and JobManager.jobs_repeat == true:
		start_filling()
		SignalHub.job_complete.emit(job_run)

	if self.button_pressed == false or JobManager.jobs_repeat == false:
		SignalHub.display.emit(job_run.job_story + "\n\n")
		SignalHub.job_complete.emit(job_run)
		current_state = State.COMPLETE
		if job_run.make_popup == true:
			make_popup(job_run)
		reset()


func reset():
	current_state = State.IDLE
	get_tree().call_group("BarButtons", "enable_self")
	self.button_pressed = false
	progress.value = 0
	visual_state &= ~VisualState.RUNNING
	update_visuals()


func reset_others(button: BarButton):
	if button != self:
		if tween and tween.is_running():
			tween.kill()
			SignalHub.display.emit("Left early...\n\n")
		reset()


func set_job(job_to_set: Job):
	job_run = job_to_set


func check_visible(_resource, _amount):
	if job_run.is_unmasked():
		job_run.shows_up = true
	if job_run.check_upper_mask():
		job_run.shows_up = false
	visible = job_run.shows_up


func update_tooltip():
	
	var line: String = "[color=white]Required:\n[/color]"
	
	for price in job_run.job_cost:
		if price.is_affordable(job_run.job_cost[price]):
			line += " [color=pale_green]" + str(job_run.job_cost[price]) + " " + price.name + ",[/color]\n"
		else: 
			line += " [color=dark_red]" + str(job_run.job_cost[price]) + " " + price.name + ",[/color]\n"
	
	if job_run.make_tooltip == true:
		for price in job_run.upper_mask:
			line += "[color=white]Max: " + str(price.amount) + "/" + str(price.max_amount) + "[/color]\n"
	
	line += "[color=white]Rewards:\n[/color]"
	
	for price in job_run.job_reward:
		if price.is_hidden:
			continue
		if price.is_full() and not price.name == "Floor Space":
			line += "[color=dark_red]" + str(job_run.job_reward[price]) + " " + price.name + ",[/color]\n"
		elif not price.is_full() and not price.name == "Floor Space":
			line += "[color=pale_green]" + str(job_run.job_reward[price]) + " " + price.name + ",[/color]\n"
		
		if price.name == "Floor Space":
			if price.is_full():
				line += "[color=dark_red]Floor Space: " + str(job_run.job_reward[price]) + "[/color]"# + "/" + str(price.max_amount)
			else:
				line += "[color=white]Floor Space: " + str(job_run.job_reward[price]) + "[/color]"# + "/" + str(price.max_amount)
	tooltip_text = line
	

func enable_self():
	disabled = false
	visual_state &= ~VisualState.DISABLED
	visual_state |= VisualState.NORMAL
	update_visuals()

func _make_custom_tooltip(for_text):
	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.text = for_text
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.fit_content = true
	return label
	

func check_affordable():
	if job_run.can_afford():
		visual_state |= VisualState.AFFORDABLE
		visual_state &= ~VisualState.UNAFFORDABLE
	else: 
		visual_state |= VisualState.UNAFFORDABLE
		visual_state &= ~VisualState.AFFORDABLE
	update_visuals()

func make_popup(popup_job: Job):
	var job_popup = preload("uid://cxse6vagl4302").instantiate()
	job_popup.label_text = popup_job.popup_text
	job_popup.button_text = popup_job.button_text
	job_popup.borderless = true
	get_tree().current_scene.display_popup(job_popup)
	
func calc_duration() -> float:
	var reward_currency: Currency = job_run.job_reward.keys()[0]
	var reward_max: int = reward_currency.get_max()
	var run_time: float = 1.0
	
	if reward_max >= 200:
		run_time = 0.5
	elif reward_max >= 100:
		run_time = 1.0
	elif reward_max >= 20:
		run_time = 2.0
	elif reward_max >= 10:
		run_time = 3.0
	elif reward_max >= 5:
		run_time = 4.0
	elif reward_max >= 1:
		run_time = 5.0
		
	return run_time
