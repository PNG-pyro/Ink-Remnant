extends Node

enum Scene { HOUSE, CITY, SAVE, LIBRARY, TOWER, MARKET, UNIVERSITY, JOURNAL, AIRSHIP, CREDITS, ALEMBIC}

var current_scene: Scene = Scene.HOUSE:
	set(new_scene):
		current_scene = new_scene
		_update_visibility()

func set_scene(new_scene: Scene):
	current_scene = new_scene

func _update_visibility():
	get_tree().call_group("ButtonFrames", "hide")
	get_tree().call_group("HouseTabFrame", "hide")
	get_tree().call_group("SaveTabFrame", "hide")
	get_tree().call_group("LibraryFrame", "hide")
	get_tree().call_group("TowerFrame", "hide")
	get_tree().call_group("MarketFrame", "hide")
	get_tree().call_group("UniversityFrame", "hide")
	get_tree().call_group("JournalFrame", "hide")
	get_tree().call_group("AirshipFrame", "hide")
	get_tree().call_group("CreditsFrame", "hide")
	get_tree().call_group("AlembicFrame", "hide")
	
	match current_scene:
		Scene.HOUSE:
			get_tree().call_group("HouseTabFrame", "show")
		Scene.CITY:
			get_tree().call_group("ButtonFrames", "show")
		Scene.SAVE:
			get_tree().call_group("SaveTabFrame", "show")
		Scene.LIBRARY:
			get_tree().call_group("LibraryFrame", "show")
		Scene.TOWER:
			get_tree().call_group("TowerFrame", "show")
		Scene.MARKET:
			get_tree().call_group("MarketFrame", "show")
		Scene.UNIVERSITY:
			get_tree().call_group("UniversityFrame", "show")
		Scene.JOURNAL:
			get_tree().call_group("JournalFrame", "show")
		Scene.AIRSHIP:
			get_tree().call_group("AirshipFrame", "show")
		Scene.CREDITS:
			get_tree().call_group("CreditsFrame", "show")
		Scene.ALEMBIC:
			get_tree().call_group("AlembicFrame", "show")
