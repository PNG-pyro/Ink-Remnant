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
	FULL = 64,
}

var visual_state: int = VisualState.NORMAL
var current_state = State.IDLE
var shiny_material: ShaderMaterial = load("res://StartScreen/new_option_mat.tres")
var rect = ColorRect.new()
var _active_label: RichTextLabel = null

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
@onready var reward_currency: Currency = job_run.job_reward.keys()[0]
@onready var reward_max: int = reward_currency.get_max()


func _ready():
	visible = job_run.is_unmasked()
	text = job_run.job_name
	toggle_mode = true
	
	shiny_material.set_shader_parameter("Speed", .3)
	shiny_material.set_shader_parameter("Rotation_deg", 6)
	shiny_material.set_shader_parameter("Line_width", .2)
	shiny_material.set_shader_parameter("Alpha", .30)
	
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.material = shiny_material
	add_child(rect)
	
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
	border.material = load("res://StartScreen/border_shader_material.tres")
	border.patch_margin_left = 16
	border.patch_margin_right = 16
	border.patch_margin_top = 16
	border.patch_margin_bottom = 16
	border.hide()
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
	
	pressed.connect(_on_pressed)
	SignalHub.resource_updated.connect(check_visible)
	SignalHub.resource_updated.connect(func(_a, _b): update_tooltip())
	#SignalHub.resource_upgraded.connect(check_visible)
	mouse_entered.connect(on_mouse_entry)
	mouse_exited.connect(on_mouse_exit)
	SignalHub.resource_updated.connect(func(_a, _b):check_affordable())
	SignalHub.job_begun.connect(update_visuals)
	if job_run.button_appears_on != "":
		SignalHub.get(job_run.button_appears_on).connect(_appear)
	if job_run.button_disappears_on != "":
		SignalHub.get(job_run.button_disappears_on).connect(_disappear)
	
	visual_state |= VisualState.AFFORDABLE
	visual_state |= VisualState.NEW
	check_affordable()

func _notification(what):
	if what == NOTIFICATION_MOUSE_EXIT:
		_active_label = null
		
func _appear():
	job_run.shows_up = true
	visible = true


func _disappear():
	job_run.shows_up = false
	visible = false


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
	
	if not visual_state & VisualState.NEW:
		if rect:
			rect.queue_free()
	
	if (visual_state & VisualState.FULL) and (visual_state & VisualState.AFFORDABLE):
		ready_label.text = "[color=yellow]- [/color]"
	elif (visual_state & VisualState.FULL) and (visual_state & VisualState.UNAFFORDABLE):
		ready_label.text = "[color=red]× [/color]"
	elif visual_state & VisualState.AFFORDABLE:
		ready_label.text = "[color=green]> [/color]"
	elif visual_state & VisualState.UNAFFORDABLE:
		ready_label.text = "[color=red]×[/color]"


func start_filling():
	var flash = true
	
	if not job_run.can_afford():
		reset()
		return
	if not job_run.has_room(flash):
		visual_state |= VisualState.FULL
		reset()
		return
	if job_run.check_upper_mask():
		reset()
		return
	if startrun == true:
		get_tree().call_group("BarButtons", "reset_others", self)
		SignalHub.display.emit(job_run.job_desc + "\n")
		startrun = false
		visual_state &= ~VisualState.NEW

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
		update_tooltip()

	if self.button_pressed == false or JobManager.jobs_repeat == false:
		if job_run.signal_name != "":
			SignalHub.get(job_run.signal_name).emit()
		if job_run.signal_name_2 != "":
			SignalHub.get(job_run.signal_name_2).emit()
		if job_run.signal_name_3 != "":
			SignalHub.get(job_run.signal_name_3).emit()
		SignalHub.display.emit(job_run.job_story + "\n\n")
		SignalHub.job_complete.emit(job_run)
		update_tooltip()
		current_state = State.COMPLETE
		
		if job_run.make_popup == true:
			make_popup(job_run)
		if job_run.start_dialogue:
			DialogueManager.show_dialogue_balloon(job_run.dialogue, "start")
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
		if price.is_affordable(job_run.job_cost[price]) and not price.name == "Floor Space":
			line += " [color=pale_green]" + str(job_run.job_cost[price]) + " " + price.name + ",[/color]\n"
		elif not price.is_affordable(job_run.job_cost[price]) and not price.name == "Floor Space":
			line += " [color=dark_red]" + str(job_run.job_cost[price]) + " " + price.name + ",[/color]\n"
	
	if job_run.make_tooltip == true:
		for price in job_run.upper_mask:
			line += "[color=white]Max: " + str(price.amount) + "/" + str(price.max_amount) + "[/color]\n"
	
	line += "[color=white]Rewards:\n[/color]"
	
	for price in job_run.job_reward:
		if price.is_hidden:
			line += "[color=white][/color]" #used to be ??? 
			continue
			
		if price.is_full() and not price.name == "Floor Space" and not price.name == "Default Currency":
			line += "[color=yellow]" + str(job_run.job_reward[price]) + " " + price.name + " - Full,[/color]\n"		
			if price.is_upgrade:
					for upgrade in price.upgrade_target:
						line += "[color=white]	- Adds " + str(price.upgrade_target[upgrade]) + " to " + upgrade.name + " max[/color]\n"
			if price.is_ticker:
					for tick in price.tick_types:
						line += "[color=white]	- Adds " + str(price.tick_types[tick]) + " per second[/color]"					
		elif not price.is_full() and not price.name == "Floor Space" and not price.name == "Default":
			line += "[color=pale_green]" + str(job_run.job_reward[price]) + " " + price.name + ",[/color]\n"
			if price.is_upgrade:
				for upgrade in price.upgrade_target:
					line += "[color=white]	- Adds " + str(price.upgrade_target[upgrade]) + " to " + upgrade.name + " max[/color]\n"
			if price.is_ticker:
				for tick in price.tick_types:
					line += "[color=white]	- Adds " + str(price.tick_types[tick]) + " " + tick.name + " per second[/color]\n"

		elif price.name == "Floor Space":
			if price.is_full():
				line += "[color=yellow]Floor Space: " + str(job_run.job_reward[price]) + " -Full![/color]\n"# + "/" + str(price.max_amount)
			else:
				line += "[color=white]Floor Space: " + str(job_run.job_reward[price]) + "[/color]\n"# + "/" + str(price.max_amount)
		else:
			line += "[color=white][/color]" #???
			
	tooltip_text = line
	if is_instance_valid(_active_label):
		_active_label.parse_bbcode(line)


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
	_active_label = label
	return _active_label
	

func check_affordable():
	if job_run.can_afford():
		visual_state |= VisualState.AFFORDABLE
		visual_state &= ~VisualState.UNAFFORDABLE
	else: 
		visual_state |= VisualState.UNAFFORDABLE
		visual_state &= ~VisualState.AFFORDABLE
	
	var flash: bool = false
	if not job_run.has_room(flash):
		visual_state |= VisualState.FULL
	else: 
		visual_state &= ~VisualState.FULL
		
	update_visuals()


func make_popup(popup_job: Job):
	var job_popup = preload("uid://cxse6vagl4302").instantiate()
	job_popup.label_text = popup_job.popup_text
	job_popup.button_text = popup_job.button_text
	job_popup.borderless = true
	get_tree().current_scene.display_popup(job_popup)


func calc_duration() -> float:

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
