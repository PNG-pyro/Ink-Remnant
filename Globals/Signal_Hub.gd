extends Node

signal resource_updated(resource_type: Currency, amount: int)
signal second_popup_closed()
#signal resource_upgraded(resource_type: Currency, max_amount: int)
signal make_visible()
signal second_popup_open()
signal second_search()
signal display(text: String)
signal hometoggle(toggle: bool)
signal state_loaded()
signal job_complete(completed: Job)
signal job_begun()
signal res_max_got(res_type: Currency, max: int)
signal volume_set(new_vol: float, mute: bool)

func update_resources(res_type: String, res_amount: int):
	resource_updated.emit(res_type, res_amount)
