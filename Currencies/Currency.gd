extends Resource
class_name Currency

@export var name: String
@export var amount: int
@export var max_amount: int: get = get_max
@export var is_ticker: bool = false
@export var tick_types: Dictionary[Currency,int] = {CurrencyManager.default_curency:0}
@export var tick_amount: int = 0
@export var is_upgrade: bool = false
@export var makes_label: bool = true
@export var has_been_seen: bool = false
@export var upgrade_target: Dictionary[Currency,int]
@export var is_hidden: bool = false
#@export var make_tooltip: bool = true

var base: int 

func is_affordable(price: int) -> bool:
	if price > amount:
		return false
	return true


func is_full() -> bool:
	if amount >= max_amount:
		return true
	return false


func add(reward: int):
	amount += reward
	amount = clamp(amount, 0, max_amount)
	SignalHub.resource_updated.emit(self, amount)


func subtract(price: int):
	amount -= price
	amount = clamp(amount, 0, max_amount)
	SignalHub.resource_updated.emit(self, amount)


func update_seen() -> bool:
	if amount > 0:
		has_been_seen = true
	return has_been_seen
	

func tick(multiplier: int):
	for currency in tick_types:
		currency.add(tick_types[currency] * multiplier)


func get_max() -> int:
	base = max_amount
	for currency in CurrencyManager.all_currencies:
		if not currency.is_upgrade:
			continue			
		if currency.upgrade_target.has(self):
			base += currency.upgrade_target[self] * currency.amount
			SignalHub.res_max_got.emit.call_deferred(self, base)
	return base
