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
signal got_mirrormancy

signal disappear_streets
signal appear_clever_artificers
signal appear_clever_stall
signal appear_glazier
signal appear_high_street
signal appear_fancy_shop
signal appear_grand_bank
signal appear_docks
signal appear_tipsy_tentacle
signal appear_thalassomancer
signal disappear_people

func update_resources(res_type: String, res_amount: int):
	resource_updated.emit(res_type, res_amount)
