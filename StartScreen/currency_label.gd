extends Label
class_name CurrencyLabel

var has_been_seen: bool = false
var label_type: Currency = CurrencyManager.default_curency
var amount: int = 0
var max_amount: int = 0
var currency_name: String = "None"


func _ready() -> void:
	#if not label_type.makes_label:
	mouse_filter = Control.MOUSE_FILTER_STOP
	SignalHub.resource_updated.connect(update_tooltip)


func text_set(currency: Currency):
	label_type = currency
	text = currency.name + ": " + str(currency.amount) + "/" + str(currency.max_amount)


func update(res_type: Currency, new_amount: int):
	var dif: int = new_amount - amount
	if dif == 0:
		return
	amount = new_amount
	text = res_type.name.capitalize() + ": " + str(amount) + "/" + str(res_type.max_amount)
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


#func flash():
	#var tween = create_tween()
	#tween.tween_property(self, "scale", Vector2(1.3, 1.0), 0.1)
	#tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)


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
	var line: String = ""
	
	if label_type.is_ticker:
		for type in label_type.tick_types: 
				line += "Adds " + str(label_type.tick_types[type]) + " " + type.name + " per second each"
	
	if label_type.is_upgrade:
		for upgrades in label_type.upgrade_target: 
			line += "Raises " + str(upgrades.name) + " cap " + str(label_type.upgrade_target[upgrades]) + " each"
	
	if label_type.make_tooltip:
		line += label_type.tooltip_says
	
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
