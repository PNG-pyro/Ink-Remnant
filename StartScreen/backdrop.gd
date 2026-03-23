extends Node

@onready var story_popup: PackedScene = load("res://StoryPopup/story_popup.tscn")
@onready var button_stack_jobs = %"ButtonStackJobs"
@onready var button_stack_trades = %"ButtonStackTrades"
@onready var button_stack_upgrades = %"ButtonStackUpgrades"

var timer: float = 0.0


func _ready():
	_on_dark_mode_pressed()
	
	button_stack_jobs.populate(JobManager.simple_jobs)
	button_stack_trades.populate(JobManager.trades)
	button_stack_upgrades.populate(JobManager.upgrades + JobManager.tickers)
	
	var starting_popup = story_popup.instantiate()
	starting_popup.label_text = "You're a homeless waif in a magical city. The only way to go from here is up!"
	starting_popup.button_text = "Search the city"
	starting_popup.borderless = true
	display_popup(starting_popup)
	#add_child(starting_popup)
	#starting_popup.popup_centered()
	
	SignalHub.second_popup_open.connect(second_popup_open_recieved)
	SignalHub.job_complete.connect(check_maxes)
	SignalHub.job_complete.connect(autosave)
	SignalHub.resource_updated.connect(end_of_content)


func _process(delta: float) -> void:
	timer += delta
	if timer >= 1.0:
		timer = 0.0
		increment_currencies()



func increment_currencies():
	for currency in CurrencyManager.all_currencies:
		if currency.is_ticker and currency.has_been_seen:
			currency.tick(currency.amount)


func second_popup_open_recieved():
	var label = "You decide you've been homless long enough - time to buy a house!"
	var button = "Search for a house"
	var sig = SignalHub.second_popup_closed
	var newpop = story_popup.instantiate()
	newpop.borderless = true
	newpop.create(label, button, sig)
	add_child(newpop)
	newpop.popup_centered()


func check_maxes(_a = null):
	for currency in CurrencyManager.all_currencies:
		if currency.has_been_seen:
			currency.get_max()


func autosave(_a = null):
	SaveManager.save(SaveManager.save_name_3)


func display_popup(popup):
	add_child(popup)
	popup.popup_centered()


func _on_light_mode_pressed() -> void:
	self.theme = load("res://theme_light.tres")
	RenderingServer.global_shader_parameter_set("Background", Color.CORNSILK)
	RenderingServer.global_shader_parameter_set("FrameColors", Color.MIDNIGHT_BLUE)


func _on_dark_mode_pressed() -> void:
	self.theme = load("res://theme_dark.tres")
	RenderingServer.global_shader_parameter_set("Background", Color.MIDNIGHT_BLUE)
	RenderingServer.global_shader_parameter_set("FrameColors", Color.CORNSILK)


func end_of_content(_a = null, _b = null):
	if CurrencyManager.eoc_check():
		print("True")
		var eoc_popup = preload("uid://cxse6vagl4302").instantiate()
		eoc_popup.label_text = "If you're seeing this, you've reached the end of the current content. Thanks for playing, I hope you had fun! Check back in a few weeks, I'll probably have added more."
		eoc_popup.button_text = "One more click..."
		eoc_popup.borderless = true
		get_tree().current_scene.display_popup(eoc_popup)
	
