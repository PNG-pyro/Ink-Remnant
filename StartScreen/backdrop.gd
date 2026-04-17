extends Node

@onready var story_popup: PackedScene = load("res://StoryPopup/story_popup.tscn")
@onready var button_stack_jobs = %"ButtonStackJobs"
@onready var button_stack_trades = %"ButtonStackTrades"
@onready var button_stack_upgrades = %"ButtonStackUpgrades"
@onready var button_stack_curator = %"ButtonStackCurator"
@onready var button_stack_librarian = %"ButtonStackLibrarian"
@onready var button_stack_books = %"ButtonStackBooks"
@onready var button_stack_inside = %"ButtonStackInside"
@onready var button_stack_outside = %"ButtonStackOutside"
@onready var button_stack_tasks = %"ButtonStackTasks"
@onready var button_stack_streets = %"ButtonStackStreets"
@onready var button_stack_stalls = %"ButtonStackStalls"
@onready var button_stack_people = %"ButtonStackPeople"
@onready var button_stack_house = %"ButtonStackHouse"
@onready var button_stack_univ1 = %"UniversityOutside"
@onready var button_stack_univ2 = %"UniversityInside"
@onready var button_stack_univ3 = %"UniversityOffices"
@onready var button_stack_journal1 = %"JournalHints"
@onready var button_stack_journal2 = %"JournalNotes"
@onready var button_stack_journal3 = %"JournalLocks"

@onready var seen_eoc = false

@export var background_color_dark: Color = Color(0.06, 0.06, 0.06, 0.063)
@export var background_color_light: Color = Color(1.0, 0.963, 0.45, 0.902)
@export var frames_color_dark: Color = Color(0.0, 0.0, 0.0, 1.0)
@export var frames_color_light: Color = Color(1.0, 1.0, 1.0, 1.0)

var timer: float = 0.0


func _ready():
	seen_eoc = false
	
	self.theme = load("res://theme_dark.tres")
	RenderingServer.global_shader_parameter_set("Background", background_color_dark)
	RenderingServer.global_shader_parameter_set("FrameColors", frames_color_light)
	$"BackdropDark".visible = true
	$"BackdropLight".visible = false
		
	button_stack_jobs.populate(JobManager.simple_jobs)
	button_stack_trades.populate(JobManager.trades)
	button_stack_upgrades.populate(JobManager.upgrades + JobManager.tickers)
	button_stack_curator.populate(JobManager.curator_jobs)
	button_stack_librarian.populate(JobManager.librarian_jobs)
	button_stack_books.populate(JobManager.research_book_jobs)
	button_stack_outside.populate(JobManager.tower_outside_jobs)
	button_stack_inside.populate(JobManager.tower_inside_jobs)
	button_stack_tasks.populate(JobManager.tower_tasks_jobs)
	button_stack_streets.populate(JobManager.market_streets_jobs)
	button_stack_stalls.populate(JobManager.market_stalls_jobs)
	button_stack_people.populate(JobManager.market_people_jobs)
	button_stack_house.populate(JobManager.house_jobs)
	button_stack_univ1.populate(JobManager.university_outside)
	button_stack_univ2.populate(JobManager.university_inside)
	button_stack_univ3.populate(JobManager.university_offices)
	button_stack_journal1.populate(JobManager.journal_hints)
	button_stack_journal2.populate(JobManager.journal_notes)
	button_stack_journal3.populate(JobManager.journal_locks)
	
	
	
	if not SaveManager.load(SaveManager.save_name_3):
		var starting_popup = story_popup.instantiate()
		starting_popup.label_text = "You're a homeless waif in a magical city. Your only keepsake is a spell-locked journal found with you at birth. The only way to go from here is up!"
		starting_popup.button_text = "Search the city"
		starting_popup.borderless = true
		display_popup(starting_popup)

	
	SignalHub.second_popup_open.connect(second_popup_open_recieved)
	SignalHub.job_complete.connect(check_maxes)
	SignalHub.job_complete.connect(autosave)
	SignalHub.resource_updated.connect(end_of_content)
	SignalHub.set_theme_dark.connect(set_dark)
	SignalHub.set_theme_light.connect(set_light)
	
	SignalHub.resource_updated.emit(CurrencyManager.get_currency("Default Currency"), 0)
	
	


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


func set_light():
	self.theme = load("res://theme_light.tres")
	RenderingServer.global_shader_parameter_set("Background", background_color_light)
	RenderingServer.global_shader_parameter_set("FrameColors", frames_color_dark)
	$"BackdropDark".visible = false
	$"BackdropLight".visible = true
	SaveManager.theme_int = 1
	SaveManager.save(SaveManager.save_name_3)


func set_dark():
	self.theme = load("res://theme_dark.tres")
	RenderingServer.global_shader_parameter_set("Background", background_color_dark)
	RenderingServer.global_shader_parameter_set("FrameColors", frames_color_light)
	$"BackdropDark".visible = true
	$"BackdropLight".visible = false
	SaveManager.theme_int = 2
	SaveManager.save(SaveManager.save_name_3)


func end_of_content(_a = null, _b = null):
	if CurrencyManager.eoc_check() and seen_eoc == false:
		seen_eoc = true
		var eoc_popup = preload("uid://cxse6vagl4302").instantiate()
		eoc_popup.label_text = "If you're seeing this, you've filled all the gagues all the way. Thanks for playing, I hope you had fun! Check back in a few weeks, I'll probably have added more."
		eoc_popup.button_text = "Just one more click..."
		eoc_popup.borderless = true
		get_tree().current_scene.display_popup(eoc_popup)
	
