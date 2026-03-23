extends Node

@onready var switch: bool = false

@onready var default_curency: Currency = load("res://Currencies/Default_currency.tres")
#@onready var floorspace: Currency = load("res://Currencies/Houses/Floor_Space.tres")

@onready var all_currencies: Array[Currency] = [
	load("res://Currencies/Books/Upgrades/Bookshelf.tres"),
	load("res://Currencies/Coins/Coins.tres"),
	load("res://Currencies/Clockwork/Clockwork.tres"),
	load("res://Currencies/Crystal/Crystal.tres"),
	load("res://Currencies/Herbs/Herbs.tres"),
	load("res://Currencies/Scrolls/Scrolls.tres"),
	load("res://Currencies/Scrolls/Ticker/Auto_quill.tres"),
	load("res://Currencies/Scrolls/Upgrades/Scroll_Case.tres"),
	load("res://Currencies/Clockwork/Upgrades/Clock.tres"),
	load("res://Currencies/Coins/Upgrades/Purse.tres"),
	load("res://Currencies/Crystal/Upgrades/velvet_box.tres"),
	load("res://Currencies/Coins/Upgrades/Lockbox.tres"),
	load("res://Currencies/Clockwork/Tickers/Clockwork_Arm.tres"),
	load("res://Currencies/Clockwork/Upgrades/Typewriter.tres"),
	load("res://Currencies/Herbs/Tickers/PlanterBox.tres"),
	load("res://Currencies/Herbs/Upgrades/Herb_Cupboard.tres"),
	load("res://Currencies/Houses/hovel.tres"),
	load("res://Currencies/Houses/Big_house.tres"),
	load("res://Currencies/Houses/Floor_Space.tres"),
	load("res://Currencies/Houses/Dimensional_Rift.tres"),
	
	load("res://Currencies/Library/Library_Card.tres"),
	load("res://Currencies/Library/LibraryLocation.tres"),
	load("res://Currencies/Library/Blue_card.tres"),
	load("res://Currencies/Library/Knowledge_Cyanomancy.tres"),
	load("res://Currencies/Library/Knowledge_Lapidamancy.tres"),
	load("res://Currencies/Library/Knowledge_Octomancy.tres"),
	load("res://Currencies/Library/Knowledge_Oneiromancy.tres"),
	load("res://Currencies/Library/Knowledge_Curator.tres"),
	load("res://Currencies/Library/Knowledge_Library_1.tres"),
	load("res://Currencies/Library/Knowledge_poppy_1.tres"),
	load("res://Currencies/Library/Knowledge_poppy_2.tres"),
	
	load("res://Currencies/Research/Research.tres"),
	load("res://Currencies/Research/Ticker/Clockwork_Dreamcatcher.tres"),
	load("res://Currencies/Books/Books.tres"),
	load("res://Currencies/Research/Star_Chart.tres"),
	load("res://Currencies/Magic/Magic_Crystal.tres"),
	load("res://Currencies/Magic/Gem_Seed.tres"),
	load("res://Currencies/Telescope/Telescope.tres"),
	load("res://Currencies/Magic/Magic.tres"),
	load("res://Currencies/Magic/Rules_of_Lapidamancy.tres"),
	load("res://Currencies/Magic/Rules_Of_Octomancy.tres"),
	load("res://Currencies/Magic/Rules_Of_Cyanomancy.tres"),
	load("res://Currencies/Magic/Rules_of_Oneiromancy.tres"),
	load("res://Currencies/Magic/Kingly_Blue.tres"),
	load("res://Currencies/Magic/Octagon.tres"),
	load("res://Currencies/Magic/Mage_Locus.tres")
]

func eoc_check() -> bool:
	var visible_currencies = all_currencies.filter(func(obj: Currency): 
		#print("Checking hidden" + obj.name + "->" + str(obj.is_hidden))
		return not obj.is_hidden and not obj.name == "Floor Space"
	)
	return visible_currencies.all(func(obj: Currency): 
		print("Checking full" + obj.name + "->" + str(obj.is_full()))
		return obj.is_full()
	)


	
