extends Resource
class_name SaveState

@export var all_currencies: Array[Currency] = (CurrencyManager.all_currencies)
@export var ui_state: int = 1 #Stores the enum from SceneManager.Scene
#@export var all_jobs: Array[Job] = JobManager.all_jobs
@export var jobs_dict: Dictionary = {}
@export var response_dict: Dictionary = {}
@export var mute: bool = false
@export var volume: float = 0.0
@export var university_visible: bool = false
@export var visible_buttons: Dictionary[String, bool]
@export var theme_int: int
@export var button_states: Dictionary = {}
