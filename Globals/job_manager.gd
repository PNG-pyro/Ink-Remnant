extends Node

var simple_jobs: Array[Job] = [
	load("res://Currencies/Herbs/Gather_Herbs.tres"),
	load("res://Currencies/Coins/Shovel.tres"),
	load("res://Currencies/Clockwork/Sort_Trash.tres"),
	load("res://Currencies/Research/Read_A_Scroll.tres"),
	load("res://Currencies/Magic/Practice_Octomancy.tres"),
	load("res://Currencies/Magic/Practice_Lapidomancy.tres"),
	load("res://Currencies/Magic/Practice_Cyanomancy.tres"),
	load("res://Currencies/Telescope/Chart_the_stars.tres"),
]

var trades: Array[Job] = [
	load("res://Currencies/Crystal/buy_crystal.tres"),
	load("res://Currencies/Scrolls/crystal_for_scrolls.tres"),
	load("res://Currencies/Herbs/Sell_Herbs.tres"),
	load("res://Currencies/Clockwork/Upgrades/Sell_clock.tres"),
	load("res://Currencies/Books/CopyScrollsIntoBook.tres"),
	load("res://Currencies/Magic/Create_Magic_Gem.tres"),
	load("res://Currencies/Magic/Create_Kingly_Blue.tres"),
]


var upgrades: Array[Job] = [
	load("res://Currencies/Clockwork/Upgrades/build_clock.tres"),
	load("res://Currencies/Clockwork/Upgrades/Build_typewriter.tres"),
	load("res://Currencies/Coins/Upgrades/buy_purse.tres"),
	load("res://Currencies/Crystal/Upgrades/buy_velvet_box.tres"),
	load("res://Currencies/Coins/Upgrades/Buy_lockbox.tres"),
	load("res://Currencies/Books/Upgrades/Buy_Bookshelf.tres"),
	load("res://Currencies/Telescope/Construct_telescope.tres"),
	load("res://Currencies/Magic/Research_Octomancy.tres"),
	load("res://Currencies/Magic/Create_Octagon.tres"),
	load("res://Currencies/Magic/Create_Gem_Seed.tres"),
	load("res://Currencies/Magic/Research_Lapidomancy.tres"),
	load("res://Currencies/Herbs/Upgrades/Buy_Herb_Cupboard.tres"),
	load("res://Currencies/Scrolls/Upgrades/Buy_Scroll_Case.tres"),
	load("res://Currencies/Magic/Research_Cyanomancy.tres"),
	load("res://Currencies/Magic/Craft_Mage_Locus.tres")
]

var tickers: Array[Job] = [
	load("res://Currencies/Clockwork/Tickers/Build_Clockwork_Arm.tres"),
	load("res://Currencies/Herbs/Tickers/Build_Planter_Box.tres"),
	load("res://Currencies/Scrolls/Ticker/Build_Auto_Quill.tres")
]

var all_jobs: Array[Job] = (tickers + upgrades + trades + simple_jobs)
