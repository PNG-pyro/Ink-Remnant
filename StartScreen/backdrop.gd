extends Node

@onready var story_popup: PackedScene = load("res://StoryPopup/story_popup.tscn")
@onready var button_stack_jobs = %"ButtonStackJobs"
@onready var button_stack_trades = %"ButtonStackTrades"
@onready var button_stack_upgrades = %"ButtonStackUpgrades"

var timer: float = 0.0


func _ready():
	button_stack_jobs.populate(JobManager.simple_jobs)
	button_stack_trades.populate(JobManager.trades)
	button_stack_upgrades.populate(JobManager.upgrades + JobManager.tickers)
	
	var starting_popup = story_popup.instantiate()
	starting_popup.label_text = "You're a homeless waif in a magical city. The only way to go from here is up!"
	starting_popup.button_text = "Search the city"
	starting_popup.borderless = true
	add_child(starting_popup)
	starting_popup.popup_centered()
	
	SignalHub.second_popup_open.connect(second_popup_open_recieved)
	SignalHub.job_complete.connect(check_maxes)
	SignalHub.job_complete.connect(autosave)


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
	add_child(newpop)
	newpop.create(label, button, sig)
	newpop.popup_centered()


func check_maxes(_a = null):
	for currency in CurrencyManager.all_currencies:
		if currency.has_been_seen:
			currency.get_max()


func autosave(_a = null):
	SaveManager.save(SaveManager.save_name_3)
