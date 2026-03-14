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
}

var visual_state: int = VisualState.NORMAL
var current_state = State.IDLE

@export var job_run: Job

@onready var startrun: bool = true
@onready var progress = ProgressBar.new()
@onready var border = NinePatchRect.new()
@onready var icon_label = RichTextLabel.new()
@onready var parent = $".."


func _ready():
	visible = job_run.is_unmasked()
	text = job_run.job_name
	toggle_mode = true
	
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
	
	icon_label.bbcode_enabled = true
	icon_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	icon_label.fit_content = true
	visual_state |= VisualState.AFFORDABLE
	update_visuals()
	icon_label.position = Vector2(10, 6)
	#icon_label.position.y = (size.y) / 2
	add_child(icon_label)
	
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
	
	if visual_state & VisualState.AFFORDABLE:
		icon_label.text = "o"
		icon_label.modulate = Color.GREEN
	elif visual_state & VisualState.UNAFFORDABLE:
		icon_label.text = "×"
		icon_label.modulate = Color.RED


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
	visual_state |= VisualState.RUNNING
	update_visuals()
	
	current_state = State.FILLING
	SignalHub.job_begun.emit()
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
	visual_state &= ~VisualState.RUNNING
	update_visuals()


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
			line += "[color=white]Max: " + str(price.amount) + "/" + str(price.max_amount) + "[/color]"
	for price in job_run.job_reward:
		if price.name == "Floor Space":
			line += "\n" + "[color=white]Floor Space: " + str(job_run.job_reward[price]) + "[/color]"# + "/" + str(price.max_amount)
	tooltip_text = line
	
func disable_others(button: BarButton):
	if button != self:
		disabled = true
		visual_state |= VisualState.DISABLED
		visual_state &= ~VisualState.NORMAL
		update_visuals()

func enable_self():
	disabled = false
	visual_state &= ~VisualState.DISABLED
	visual_state |= VisualState.NORMAL
	update_visuals()

func _make_custom_tooltip(for_text):
	#var panel = Panel.new()
	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.text = for_text
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.fit_content = true
	#label.theme = load("res://theme_light.tres")
	#panel.add_child(label)
	return label

func check_affordable():
	if job_run.can_afford():
		visual_state |= VisualState.AFFORDABLE
		visual_state &= ~VisualState.UNAFFORDABLE
	else: 
		visual_state |= VisualState.UNAFFORDABLE
		visual_state &= ~VisualState.AFFORDABLE
