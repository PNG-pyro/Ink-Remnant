extends VBoxContainer
class_name CurrencyStack

#var my_theme: Theme = load("res://tween_theme.tres")
var visible_labels: Array[CurrencyLabel] = []


func _ready():
	CurrencyManager.all_currencies.sort_custom(func(a, b): return a.name < b.name)
	update_list()
	SignalHub.resource_updated.connect(re_update)	
	#SignalHub.job_complete.connect(re_upgrade)
	SignalHub.res_max_got.connect(re_upgrade)


func update_list():
	for currency in CurrencyManager.all_currencies:
		if not should_include(currency):
			continue
		var currency_label = CurrencyLabel.new()
		currency_label.visible = currency.update_seen()
		currency_label.text_set(currency)	
		visible_labels.append(currency_label)
		add_child(currency_label)


func should_include(currency: Currency) -> bool:
	return currency.makes_label


func re_update(res_type: Currency, amount: int):
	for label in visible_labels:
		label.visible = label.label_type.update_seen()
		if label.label_type.name != res_type.name:
			continue
		label.update(res_type, amount)


func re_upgrade(res_type: Currency, amount: int):
	for label in visible_labels:
		if label.label_type.name != res_type.name:
			continue
		label.visible = label.label_type.update_seen()
		label.upgrade(res_type, amount)
