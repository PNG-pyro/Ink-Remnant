extends Resource
class_name SaveState

@export var all_currencies: Array[Currency] = (CurrencyManager.all_currencies)
@export var ui_state: int = 1 #Stores the enum from SceneManager.Scene
@export var all_jobs: Array[Job] = JobManager.all_jobs
