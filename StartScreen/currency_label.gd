extends Label
class_name CurrencyLabel

var has_been_seen: bool = false
var label_type: Currency = CurrencyManager.default_curency
var amount: int = 0
var max_amount: int = 0
var currency_name: String = "None"
var text_color = Color.YELLOW
var theme_color = Color.WHITE


func _ready() -> void:
	#if not label_type.makes_label:
	mouse_filter = Control.MOUSE_FILTER_STOP
	SignalHub.resource_updated.connect(update_tooltip)
	SignalHub.resource_updated.connect(is_full)
	SignalHub.flash_currency.connect(flash)


func text_set(currency: Currency):
	label_type = currency
	text = currency.name + ": " + str(currency.amount) + "/" + str(currency.max_amount)


func update(res_type: Currency, new_amount: int):
	var dif: int = new_amount - amount
	if dif == 0:
		return
	amount = new_amount
	text = res_type.name + ": " + str(amount) + "/" + str(res_type.max_amount)
	if dif > 0:
		spawn_popup(dif)
	if dif < 0:
		spawn_neg_popup(dif)


func upgrade(res_type: Currency, new_amount: int):
	var dif: int = new_amount - max_amount
	if dif == 0:
		return
	max_amount = new_amount
	text = res_type.name.capitalize() + ": " + str(res_type.amount) + "/" + str(new_amount)
	#if dif > 0:
		#spawn_popup(dif)
	#if dif < 0:
		#spawn_neg_popup(dif)


func flash(name_to_flash):
	if name_to_flash == label_type.name:
		
		color_text()
		
		var scale_tween = create_tween()
		scale_tween.tween_property(self, "scale", Vector2(1.3, 1.0), 0.1)
		scale_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
		
		pivot_offset = get_minimum_size()/2
		var pivot_tween = create_tween()
		pivot_tween.tween_property(self, "rotation", 0.1, 0.05)
		pivot_tween.tween_property(self, "rotation", -0.1, 0.1)
		pivot_tween.tween_property(self, "rotation", 0.0, 0.05)
		
		var color_tween = create_tween()
		color_tween.tween_property(self, "modulate", text_color, 0.5)
		color_tween.tween_property(self, "modulate", Color.WHITE, 0.1)


func spawn_popup(txt_amount: int):
	var popup = Label.new()
	popup.text = "+%d" % txt_amount
	add_child(popup)
	popup.global_position = global_position + Vector2(get_minimum_size().x, 0)
	var tween = create_tween()
	tween.tween_property(popup, "position", popup.position + Vector2(30, -10), 0.6)
	tween.parallel().tween_property(popup, "modulate:a", 0.0, 0.6)
	tween.tween_callback(popup.queue_free)


func spawn_neg_popup(txt_amount: int):
	var popup = Label.new()
	popup.text = "%d" % txt_amount
	add_child(popup)
	popup.global_position = global_position + Vector2(get_minimum_size().x, 0)
	var tween = create_tween()
	tween.tween_property(popup, "position", popup.position + Vector2(30, 10), 0.6)
	tween.parallel().tween_property(popup, "modulate:a", 0.0, 0.6)
	tween.tween_callback(popup.queue_free)
	

func update_tooltip(_a = null, _b = null):
	var line: String = "[color=white] "
	
	if label_type.is_ticker:
		for type in label_type.tick_types: 
				line += "Adds " + str(label_type.tick_types[type]) + " " + type.name + " per second each\n"
	elif label_type.is_upgrade:
		for upgrades in label_type.upgrade_target: 
			line += "Raises " + str(upgrades.name) + " cap " + str(label_type.upgrade_target[upgrades]) + " each\n"
	elif label_type.make_tooltip:
		line += label_type.tooltip_says
	elif not label_type.is_hidden:
		for item in CurrencyManager.all_currencies:
			if not item.is_ticker:
				continue
			if not item.tick_types.has(label_type):
				continue
			if item.amount == 0:
				continue
			line += "Plus " + str(item.tick_types[label_type] * item.amount) + " per second from " + str(item.amount) + " " + item.name + "\n"
	line += "[/color]"
	tooltip_text = line
	
func _make_custom_tooltip(for_text):
	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.text = for_text
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.fit_content = true
	return label
	
func is_full(_a = null, _b = null):
	if color_text():
		
		if label_type.is_full():
			self.add_theme_color_override("font_color", text_color)
		else:
			self.remove_theme_color_override("font_color")
		
func color_text() -> bool:
	if not label_type.makes_label:
		return false
	
	if get_tree().current_scene.theme == load("res://theme_dark.tres"):
		text_color = Color.YELLOW
		theme_color = Color.WHITE
	else:
		text_color = Color.BLUE
		theme_color = Color.BLACK
	return true
