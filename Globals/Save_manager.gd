extends Node

var save_name_1: String = "Slot 1"
var save_name_2: String = "Slot 2"
var save_name_3: String = "Autosave"


func save(savename: String):
	var save_state: SaveState = SaveState.new()
	save_state.ui_state = SceneManager.current_scene
	
	save_state.all_currencies = []
	for currency in CurrencyManager.all_currencies:
		save_state.all_currencies.append(currency.duplicate())
	ResourceSaver.save(save_state, "user://" + savename + ".tres")
	
	if savename != save_name_3:
		SignalHub.display.emit("Game saved: " + savename + "\n\n")
	
func load(savename: String):
	if not ResourceLoader.exists("user://" + savename + ".tres"):
		return
	var save_state: SaveState = ResourceLoader.load("user://" + savename + ".tres")
	
	SceneManager.set_scene(save_state.ui_state as SceneManager.Scene)
	
	for saved_currency in save_state.all_currencies:
		for currency in CurrencyManager.all_currencies:
			if saved_currency.name == currency.name:
				currency.amount = saved_currency.amount
				currency.has_been_seen = saved_currency.has_been_seen
				SignalHub.resource_updated.emit(currency, currency.amount)
	
	for currency in CurrencyManager.all_currencies:
		currency.get_max()
		
	SignalHub.display.emit("Game loaded: " + savename + "\n\n")
