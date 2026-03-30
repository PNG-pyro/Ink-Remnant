extends Node

@onready var jobs_repeat: bool = true

var simple_jobs: Array[Job] = [
	load("res://Currencies/Herbs/Gather_Herbs.tres"),
	load("res://Currencies/Coins/Shovel.tres"),
	load("res://Currencies/Clockwork/Sort_Trash.tres"),
	load("res://Currencies/Research/Read_A_Scroll.tres"),
	load("res://Currencies/Magic/Practice_Octomancy.tres"),
	load("res://Currencies/Magic/Practice_Lapidomancy.tres"),
	load("res://Currencies/Magic/Practice_Cyanomancy.tres"),
	load("res://Currencies/Magic/Oneiromancy/Practice_Oneiromancy.tres"),
	load("res://Currencies/Magic/Mirrormancy/Practice_Mirrormancy.tres"),



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
	load("res://Currencies/Coins/Sell_Book.tres"),
	load("res://Currencies/Mirror/Order_a_Mirror.tres")
]


var upgrades: Array[Job] = [
	load("res://Currencies/Books/Upgrades/Buy_Bookshelf.tres"),
	load("res://Currencies/Coins/Upgrades/Buy_lockbox.tres"),
	load("res://Currencies/Coins/Upgrades/buy_purse.tres"),
	load("res://Currencies/Clockwork/Upgrades/build_clock.tres"),
	load("res://Currencies/Clockwork/Upgrades/Build_typewriter.tres"),
	load("res://Currencies/Crystal/Upgrades/buy_velvet_box.tres"),
	load("res://Currencies/Herbs/Upgrades/Buy_Herb_Cupboard.tres"),
	load("res://Currencies/Magic/Create_Octagon.tres"),
	load("res://Currencies/Magic/Create_Gem_Seed.tres"),
	load("res://Currencies/Magic/Craft_Mage_Locus.tres"),
	
	load("res://Currencies/Magic/Research_Octomancy.tres"),
	load("res://Currencies/Magic/Research_Lapidomancy.tres"),
	load("res://Currencies/Magic/Research_Cyanomancy.tres"),
	load("res://Currencies/Magic/Oneiromancy/Research_Oneiromancy.tres"),
	load("res://Currencies/Magic/Mirrormancy/Research_Mirrormancy.tres"),
	
	load("res://Currencies/Scrolls/Upgrades/Buy_Scroll_Case.tres"),
	load("res://Currencies/Telescope/Construct_telescope.tres"),
]

var tickers: Array[Job] = [
	load("res://Currencies/Clockwork/Tickers/Build_Clockwork_Arm.tres"),
	load("res://Currencies/Herbs/Tickers/Build_Planter_Box.tres"),
	load("res://Currencies/Scrolls/Ticker/Build_Auto_Quill.tres"),
	load("res://Currencies/Research/Ticker/Craft_Clockwork_Dreamcatcher.tres"),
	load("res://Currencies/Books/Ticker/Craft_Cogmind.tres")
]

var house_jobs: Array[Job] = [
	load("res://Currencies/Houses/Acquire_hovel.tres"),
	load("res://Currencies/Houses/Buy_big_house.tres"),
	load("res://Currencies/Houses/Make_Dimension_Rift.tres"),
	load("res://Currencies/Houses/Rooms/Build_Library.tres"),
	load("res://Currencies/Houses/Rooms/Build_Vault.tres"),
	load("res://Currencies/Houses/Rooms/Build_Garden_Shed.tres")
]

var curator_jobs: Array[Job] = [
	load("res://Currencies/Library/Curator/DiscoverLibrary.tres"),
	load("res://Currencies/Library/Curator/Get_Library_Card.tres"),
	load("res://Currencies/Library/Curator/Speak_with_Curator.tres"),
	load("res://Currencies/Library/Curator/Speak_with_Curator_2.tres"),
	load("res://Currencies/Library/Curator/Speak_with_Curator_3.tres"),
	load("res://Currencies/Library/Curator/Speak_with_Curator_4.tres"),
	load("res://Currencies/Library/Curator/Offer_Kingly_Blue.tres"),
	load("res://Currencies/Library/Curator/Ask_Octomancy.tres"),
	load("res://Currencies/Library/Curator/Ask_Octomancy_2.tres"),
	load("res://Currencies/Library/Curator/Ask_Octomancy_3.tres"),
]

var librarian_jobs: Array[Job] = [
	load("res://Currencies/Library/Librarian/Speak_with_librarian.tres"),
	load("res://Currencies/Library/Librarian/Speak_with_librarian2.tres"),
	load("res://Currencies/Library/Librarian/Speak_with_librarian3.tres"), 
	load("res://Currencies/Library/Librarian/Speak_with_librarian4.tres"),
	load("res://Currencies/Library/Librarian/Ask_Cyanomancy.tres"),
	load("res://Currencies/Library/Librarian/Ask_Cyanomancy_2.tres"),
	load("res://Currencies/Library/Librarian/Ask_Cyanomancy_3.tres"),
]

var research_book_jobs: Array[Job] = [
	load("res://Currencies/Library/Bookshelves/Research_The_City.tres"),
	load("res://Currencies/Library/Bookshelves/Research_Octomancy.tres"),
	load("res://Currencies/Library/Bookshelves/Research_Lapidamancy.tres"),
	load("res://Currencies/Library/Bookshelves/Research_Cyanomancy.tres"),
	load("res://Currencies/Library/Bookshelves/Research_Oneiromancy.tres"),
]

var tower_outside_jobs: Array[Job] = [
	load("res://Currencies/Tower/Outside/Examine_Tower.tres"),
	load("res://Currencies/Tower/Outside/Forge_Through.tres"),
	load("res://Currencies/Tower/Outside/Look_around_tower.tres"),
	load("res://Currencies/Tower/Outside/Examine_door.tres"),
	load("res://Currencies/Tower/Outside/Open_door.tres"),
	load("res://Currencies/Tower/Outside/Examine_City.tres"),
]

var tower_inside_jobs: Array[Job] = [
	load("res://Currencies/Tower/Inside/Look_around.tres"),
	load("res://Currencies/Tower/Inside/Examine_the_walls.tres"),
	load("res://Currencies/Tower/Inside/Examine_the_peak.tres"),
	load("res://Currencies/Tower/Inside/Examine_the_core.tres"),
	
]

var tower_tasks_jobs: Array[Job] = [
	load("res://Currencies/Tower/Tasks/Uncover_object.tres"),
	load("res://Currencies/Tower/Tasks/Power_the_chair.tres"),
	load("res://Currencies/Tower/Tasks/Discover_Mirrormancy.tres"),
	load("res://Currencies/Tower/Tasks/Power_the_chair_2.tres")
	
]

var market_streets_jobs: Array[Job] = [
	#load("res://Currencies/Market/Streets/Walk_the_streets.tres"),
	load("res://Currencies/Market/Streets/Visit_Clever_Artificers.tres"),
	load("res://Currencies/Market/Streets/Visit_High_Street.tres"),
]

var market_stalls_jobs: Array[Job] = [
	load("res://Currencies/Market/Stalls/CleverArtificers/Examine_Clever_Artificers.tres"),
	load("res://Currencies/Market/Stalls/CleverArtificers/Set_up_Stall.tres"),
	load("res://Currencies/Market/Stalls/CleverArtificers/Visit_a_glazier.tres"),
	load("res://Currencies/Market/Stalls/HighStreet/Visit_a_fancy_shop.tres"),
	load("res://Currencies/Market/Stalls/HighStreet/Visit_Grand_Bank.tres"),
]

var market_people_jobs: Array[Job] = [
	load("res://Currencies/Market/People/Clever_stall_people/Sell_Clockwork.tres"),
	load("res://Currencies/Market/People/Clever_stall_people/Sell_Clocks.tres"),
	load("res://Currencies/Market/People/Clever_stall_people/Sell_Typewriter.tres"),
	load("res://Currencies/Market/People/Clever_stall_people/Sell_Telescope.tres"),
	load("res://Currencies/Market/People/glazier people/Buy_Mirror.tres"),
	load("res://Currencies/Market/People/Fancy_shop_people/Buy_Hat.tres"),
	load("res://Currencies/Market/People/Fancy_shop_people/Buy_Shoes.tres"),
	load("res://Currencies/Market/People/Bank_people/Speak_with_teller.tres"),
]

var all_jobs: Array[Job] = (tickers + 
upgrades + 
trades + 
simple_jobs + 
house_jobs + 
curator_jobs +
librarian_jobs + 
research_book_jobs +
tower_outside_jobs +
tower_inside_jobs +
tower_tasks_jobs + 
market_streets_jobs +
market_stalls_jobs +
market_people_jobs
)
