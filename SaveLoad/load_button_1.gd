extends Button

func _on_pressed() -> void:
	

	for currency in CurrencyManager.all_currencies:
		currency.amount = 0
		if not currency.stays_visible:
			currency.has_been_seen = false
	for job in JobManager.all_jobs:
		job.shows_up = false
	SaveManager.university_visible = false
	ResponseManager.visited_responses = {}
	SaveManager.visible_buttons = {}
	#get_tree().reload_current_scene()
	
	SaveManager.load(SaveManager.save_name_1)
