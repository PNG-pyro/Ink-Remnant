extends Node

const SAVE_HEADER = "Ink_Remnant_Save_V1"

var save_name_1: String = "Slot 1"
var save_name_2: String = "Slot 2"
var save_name_3: String = "Autosave"
var last_focus_time: float = 0
var university_visible: bool = false
var visible_buttons: Dictionary[String, bool]
var theme_int: int



var focus_gained_callback
var focus_lost_callback


func load_autosave():
	load(save_name_3)


func save(savename: String) -> SaveState:
	var save_state: SaveState = SaveState.new()
	save_state.ui_state = SceneManager.current_scene
	
	save_state.all_currencies = []
	for currency in CurrencyManager.all_currencies:
		save_state.all_currencies.append(currency.duplicate())
	
	for job in JobManager.all_jobs:
		save_state.jobs_dict[job.job_name] = job.shows_up
		
	for button in visible_buttons:
		if button: 
			save_state.visible_buttons[button] = visible_buttons[button]
		
	for button in get_tree().get_nodes_in_group("BarButtons"):
		save_state.button_states[button.job_run.job_name] = button.visual_state
	
	save_state.theme_int = theme_int
	save_state.mute = BackgroundMusicPlayer.stream_paused
	save_state.volume = BackgroundMusicPlayer.volume_linear
	save_state.university_visible = university_visible
	save_state.response_dict = ResponseManager.visited_responses
	
	ResourceSaver.save(save_state, "user://" + savename + ".tres")
	
	if savename != save_name_3:
		SignalHub.display.emit("Game saved: " + savename + "\n\n")
		
	return save_state


func load(savename: String) -> bool:
	if not ResourceLoader.exists("user://" + savename + ".tres"):
		return false
	var save_state: SaveState = ResourceLoader.load("user://" + savename + ".tres")
	if load_save(save_state):
		SignalHub.display.emit("Game loaded: " + savename + "\n\n")
	else:
		SignalHub.display.emit("Oops, something went wrong... New game begun!")
	SignalHub.make_visible.emit()
	return true


func load_save(save_to_load: SaveState) -> bool:
	if not save_to_load:
		return false
	SceneManager.set_scene(save_to_load.ui_state as SceneManager.Scene)
	university_visible = save_to_load.university_visible
	
	theme_int = save_to_load.theme_int
	if theme_int == 1:
		SignalHub.set_theme_light.emit()
	if theme_int == 2:
		SignalHub.set_theme_dark.emit()

	for saved_currency in save_to_load.all_currencies:
		for currency in CurrencyManager.all_currencies:
			if saved_currency.name == currency.name:
				currency.amount = saved_currency.amount
				currency.has_been_seen = saved_currency.has_been_seen
				SignalHub.resource_updated.emit(currency, currency.amount)

	for saved_job in save_to_load.jobs_dict:
		for job in JobManager.all_jobs:
			if saved_job == job.job_name:
				job.shows_up = save_to_load.jobs_dict[saved_job]
	
	for saved_button in save_to_load.visible_buttons:
		visible_buttons[saved_button] = save_to_load.visible_buttons[saved_button]
		
	
	for button in get_tree().get_nodes_in_group("BarButtons"):
		if button.job_run.job_name in save_to_load.button_states:
			button.visual_state = save_to_load.button_states[button.job_run.job_name]
			button.update_visuals()
			

	SignalHub.volume_set.emit(save_to_load.volume, save_to_load.mute)
	ResponseManager.visited_responses = save_to_load.response_dict
	
	for currency in CurrencyManager.all_currencies:
		currency.get_max()

	SceneManager.set_scene(SceneManager.Scene.CITY)
	

		
	return true
