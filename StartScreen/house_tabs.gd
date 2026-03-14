extends VFlowContainer

var visible_labels: Array[CurrencyLabel] = []

func _ready():
	#SignalHub.hometoggle.connect(set_vis)
	setup_floorspace()
	SignalHub.resource_updated.connect(re_update)
	SignalHub.res_max_got.connect(re_upgrade)


func setup_floorspace():
	for currency in CurrencyManager.all_currencies:
		if currency.makes_label:
			continue
		var upgrade_label = CurrencyLabel.new()
		upgrade_label.text_set(currency)
		upgrade_label.visible = currency.update_seen()
		upgrade_label.custom_minimum_size = Vector2(300, 0)
		visible_labels.append(upgrade_label)
		add_child(upgrade_label)


func re_upgrade(res_type: Currency, new_max: int):
	for label in visible_labels:
		if label.label_type != res_type:
			continue	
		label.visible = res_type.update_seen()
		label.upgrade(res_type, new_max)
		
		
func re_update(res_type: Currency, new_amount: int):
	for label in visible_labels:
		if label.label_type != res_type:
			continue
		label.visible = res_type.update_seen()
		label.update(res_type, new_amount)
