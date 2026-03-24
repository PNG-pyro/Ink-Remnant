extends Node

const SAVE_HEADER = "Ink_Remnant_Save_V1"

var save_name_1: String = "Slot 1"
var save_name_2: String = "Slot 2"
var save_name_3: String = "Autosave"
var last_focus_time: float = 0


func save(savename: String) -> SaveState:
	var save_state: SaveState = SaveState.new()
	save_state.ui_state = SceneManager.current_scene
	
	save_state.all_currencies = []
	for currency in CurrencyManager.all_currencies:
		save_state.all_currencies.append(currency.duplicate())
	
	save_state.all_jobs = []
	for job in JobManager.all_jobs:
		save_state.all_jobs.append(job.duplicate())
		
	save_state.mute = BackgroundMusicPlayer.stream_paused
	save_state.volume = BackgroundMusicPlayer.volume_linear
	
	ResourceSaver.save(save_state, "user://" + savename + ".tres")
	
	if savename != save_name_3:
		SignalHub.display.emit("Game saved: " + savename + "\n\n")
		
	return save_state


func load(savename: String):
	if not ResourceLoader.exists("user://" + savename + ".tres"):
		return
	var save_state: SaveState = ResourceLoader.load("user://" + savename + ".tres")
	load_save(save_state)
	SignalHub.display.emit("Game loaded: " + savename + "\n\n")
	

func load_save(save_to_load: SaveState):
	SceneManager.set_scene(save_to_load.ui_state as SceneManager.Scene)
	
	for saved_currency in save_to_load.all_currencies:
		for currency in CurrencyManager.all_currencies:
			if saved_currency.name == currency.name:
				currency.amount = saved_currency.amount
				currency.has_been_seen = saved_currency.has_been_seen
				SignalHub.resource_updated.emit(currency, currency.amount)
				
	for saved_job in save_to_load.all_jobs:
		for job in JobManager.all_jobs:
			if saved_job.job_name == job.job_name:
				job.shows_up = saved_job.shows_up
				
	#BackgroundMusicPlayer.volume_db = save_state.volume
	#BackgroundMusicPlayer.stream_paused = save_state.mute
	
	SignalHub.volume_set.emit(save_to_load.volume, save_to_load.mute)
	
	for currency in CurrencyManager.all_currencies:
		currency.get_max()
		
	
	SceneManager.set_scene(SceneManager.Scene.CITY)


func _notification(what):
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			# window lost focus - keep running but maybe throttle fps
			Engine.max_fps = 10
			last_focus_time = Time.get_unix_time_from_system() 
		NOTIFICATION_APPLICATION_FOCUS_IN:
			Engine.max_fps = 60  # 0 = unlimited, back to normal
			if last_focus_time > 0:
				var elapsed = Time.get_unix_time_from_system() - last_focus_time
				apply_catch_up(elapsed)
				last_focus_time = 0.0
				
func apply_catch_up(seconds: float):
	var ticks_missed = floor(seconds)
	for i in ticks_missed:
		get_tree().current_scene.increment_currencies()
