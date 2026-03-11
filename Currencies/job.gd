extends Resource
class_name Job 

@export var job_name: String
@export var job_desc: String
@export var job_story: String
@export var job_duration: int
@export var job_reward: Dictionary[Currency,int]
@export var job_cost: Dictionary[Currency, int]
@export var job_mask: Dictionary[Currency, int]
@export var upper_mask: Array[Currency]
#@export var is_upgrade: bool = false
#@export var upgrade_name: Currency = CurrencyManager.default_curency
@export var shows_up: bool = false
@export var make_tooltip: bool = true


func pay_reward():
	for reward in job_reward:
		reward.add(job_reward[reward])


func pay_costs():
	for price in job_cost:
		price.subtract(job_cost[price])


func has_room() -> bool:
	var room_left: bool = true 
	#if is_upgrade:
		#return room_left
	for reward in job_reward:
		if reward.is_full():
			room_left = false
	return room_left


func can_afford() -> bool:
	var affordable: bool = true
	for cost: Currency in job_cost.keys():
		if not cost.is_affordable(job_cost[cost]):
			affordable = false
	return affordable


func is_unmasked() -> bool:
	var masked = true
	for mask in job_mask.keys():
		if not mask.is_affordable(job_mask[mask]):
			masked = false
	return masked


func check_upper_mask() -> bool:
	var masked = false
	for mask in upper_mask:
		if mask.is_full():
			masked = true
	return masked


#func has_upgrade_room() -> bool:
	#return not upgrade_name.is_full()
