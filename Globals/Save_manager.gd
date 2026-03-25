extends Node

const SAVE_HEADER = "Ink_Remnant_Save_V1"

var save_name_1: String = "Slot 1"
var save_name_2: String = "Slot 2"
var save_name_3: String = "Autosave"
var last_focus_time: float = 0

var focus_gained_callback
var focus_lost_callback


func _ready() -> void:
	if OS.get_name() == "Web":
		_setup_web_visibility()


func load_autosave():
	load(save_name_3)


func _setup_web_visibility():
	# create godot callbacks that javascript can call
	focus_lost_callback = JavaScriptBridge.create_callback(_on_focus_lost)
	focus_gained_callback = JavaScriptBridge.create_callback(_on_focus_gained)
	
	# expose them to javascript on the window object
	var window = JavaScriptBridge.get_interface("window")
	window.focus_lost = focus_lost_callback
	window.focus_gained = focus_gained_callback
		
	# tell the browser to call them when visibility changes
	JavaScriptBridge.eval("""
		document.addEventListener('visibilitychange', function() {
			if (document.hidden) {
				window.focus_lost();
		} else {
				window.focus_gained();
			}
		});
	""")

func _on_focus_lost(_args):
	last_focus_time = Time.get_unix_time_from_system()


func _on_focus_gained(_args):
	if last_focus_time > 0:
		var elapsed = Time.get_unix_time_from_system() - last_focus_time
		apply_catch_up(elapsed)
		last_focus_time = 0.0


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


func load(savename: String) -> bool:
	if not ResourceLoader.exists("user://" + savename + ".tres"):
		return false
	var save_state: SaveState = ResourceLoader.load("user://" + savename + ".tres")
	load_save(save_state)
	SignalHub.display.emit("Game loaded: " + savename + "\n\n")
	SignalHub.make_visible.emit()
	return true
	

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
	if OS.get_name() == "Web":
		return
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
