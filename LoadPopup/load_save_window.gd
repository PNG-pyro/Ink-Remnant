extends Window

const SAVE_HEADER = SaveManager.SAVE_HEADER

@onready var load_string = $"LoadString"
@onready var save_state: SaveState


func _on_paste_pressed() -> void:
	get_text()


func _on_close_pressed() -> void:
	visible = false


func _on_clear_pressed() -> void:
	load_string.text = ""
	save_state = null


func _on_load_pressed() -> void:
	
	for currency in CurrencyManager.all_currencies:
		currency.amount = 0
		if not currency.stays_visible:
			currency.has_been_seen = false
			
	for job in JobManager.all_jobs:
		job.shows_up = false
		
	SaveManager.university_visible = false
	ResponseManager.visited_responses = {}
	SaveManager.visible_buttons = {}
	
	var string_save: String = load_string.text
	string_save = Marshalls.base64_to_raw(string_save).get_string_from_utf8()
	
	if not string_save.begins_with(SAVE_HEADER):
		SignalHub.display.emit("Couldn't load save! Double-check your save string.\n\n")
	else:
		string_save = string_save.trim_prefix(SAVE_HEADER)
		save_state = str_to_var(string_save) as SaveState
		
	if save_state:
		SaveManager.load_save(save_state)
		visible = false
		SignalHub.display.emit("Save imported!\n\n")

func _on_import_save_pressed() -> void:
	visible = true
	get_text()


func get_text():
	var string_save = DisplayServer.clipboard_get()
	load_string.text = string_save
