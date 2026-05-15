extends Node

@onready var switch: bool = false

@onready var default_curency: Currency = load("res://Currencies/Default_currency.tres")
#@onready var floorspace: Currency = load("res://Currencies/Houses/Floor_Space.tres")

@onready var all_currencies: Array[Currency] = [
	load("res://Currencies/Books/Books.tres"),
	load("res://Currencies/Books/Upgrades/Bookshelf.tres"),
	load("res://Currencies/Books/Ticker/Holographic_Cogmind.tres"),
	load("res://Currencies/Coins/Coins.tres"),
	load("res://Currencies/Coins/Upgrades/Lockbox.tres"),
	load("res://Currencies/Coins/Upgrades/Purse.tres"),
	load("res://Currencies/Clockwork/Clockwork.tres"),
	load("res://Currencies/Clockwork/Tickers/Clockwork_Arm.tres"),
	load("res://Currencies/Clockwork/Upgrades/Typewriter.tres"),
	load("res://Currencies/Clockwork/Upgrades/Clock.tres"),
	load("res://Currencies/Clockwork_Isle/Cabochon_Tractors.tres"),
	load("res://Currencies/Clockwork_Isle/Cyanometric_Tourbillon.tres"),
	load("res://Currencies/Clockwork_Isle/Dreamsilver_Barometer.tres"),
	load("res://Currencies/Clockwork_Isle/Eightfold_Escapement.tres"),
	load("res://Currencies/Clockwork_Isle/Hadean_Chronometer.tres"),
	load("res://Currencies/Clockwork_Isle/Specular_armillary.tres"),
	load("res://Currencies/Crystal/Crystal.tres"),
	load("res://Currencies/Crystal/Upgrades/velvet_box.tres"),
	load("res://Currencies/Deep_Water/Deep_Water.tres"),
	load("res://Currencies/Deep_Water/Knowledge_deep_water.tres"),
	load("res://Currencies/Deep_Water/Upgrades/Mirrored_Jug.tres"),
	load("res://Currencies/Default_currency.tres"),
	load("res://Currencies/Dreamsilver/Dream_Silver.tres"),
	load("res://Currencies/Dreamsilver/Upgrade/dream_spindle.tres"),
	load("res://Currencies/Herbs/Tickers/PlanterBox.tres"),
	load("res://Currencies/Herbs/Upgrades/Herb_Cupboard.tres"),
	load("res://Currencies/Herbs/Herbs.tres"),
	load("res://Currencies/Houses/hovel.tres"),
	load("res://Currencies/Houses/Big_house.tres"),
	load("res://Currencies/Houses/Floor_Space.tres"),
	load("res://Currencies/Houses/Dimensional_Rift.tres"),
	load("res://Currencies/Houses/Rooms/Library.tres"),
	load("res://Currencies/Houses/Rooms/GardenShed.tres"),
	load("res://Currencies/Houses/Rooms/Vault.tres"),
	load("res://Currencies/Houses/Dimensional_Fold.tres"),
	load("res://Currencies/Houses/Rooms/Mechanics_room.tres"),
	load("res://Currencies/Journal/locks/Open_lock_1.tres"),
	load("res://Currencies/Journal/locks/Open_lock_2.tres"),
	load("res://Currencies/Journal/locks/Open_lock_3.tres"),
	load("res://Currencies/Journal/Knowledge_journal.tres"),
	
	load("res://Currencies/Scrolls/Scrolls.tres"),
	load("res://Currencies/Scrolls/Ticker/Auto_quill.tres"),
	load("res://Currencies/Scrolls/Upgrades/Scroll_Case.tres"),
	
	load("res://Currencies/Library/Library_Card.tres"),
	load("res://Currencies/Library/LibraryLocation.tres"),
	load("res://Currencies/Library/Blue_card.tres"),
	
	load("res://Currencies/Magic/Calcimancy/Knowledge_Calcimancy.tres"),
	load("res://Currencies/Magic/Cyanomancy/Knowledge_Cyanomancy.tres"),
	load("res://Currencies/Magic/Lapidamancy/Knowledge_Lapidamancy.tres"),
	load("res://Currencies/Magic/Octomancy/Knowledge_Octomancy.tres"),
	load("res://Currencies/Magic/Oneiromancy/Knowledge_Oneiromancy.tres"),
	load("res://Currencies/Magic/Mirrormancy/Knowledge_Mirrormancy.tres"),
	load("res://Currencies/Magic/Thalassomancy/Knowledge_thalassomancy.tres"),
	load("res://Currencies/Magic/Ergomancy/Knowledge_Ergomancy.tres"),
	load("res://Currencies/Magic/Apimancy/Knowledge_Apimancy.tres"),
	
	load("res://Currencies/Library/Knowledge_Curator.tres"),
	load("res://Currencies/Library/Curator/Currencies/Curator_Octomancy.tres"),
	
	load("res://Currencies/Library/Knowledge_Library_1.tres"),
	load("res://Currencies/Library/Knowledge_poppy_1.tres"),
	load("res://Currencies/Library/Knowledge_poppy_2.tres"),
	load("res://Currencies/Library/Librarian/Currencies/Librarian_cyanomancy.tres"),
	
	load("res://Currencies/Market/People/Fancy_shop_people/hat.tres"),
	load("res://Currencies/Market/People/Fancy_shop_people/shoes.tres"),
	load("res://Currencies/Market/People/TipsyTentacle/Octagonal_cup.tres"),
	load("res://Currencies/Market/People/Bank_people/Bank_Card.tres"),
	
	load("res://Currencies/Tower/Knowledge_of_tower.tres"),
	load("res://Currencies/Tower/Knowledge_of_tower2.tres"),
	load("res://Currencies/Tower/Knowledge_of_tower3.tres"),
	load("res://Currencies/Tower/Knowledge_of_tower4.tres"),
	load("res://Currencies/Tower/Knowledge_of_tower5.tres"),
	load("res://Currencies/Tower/Knowledge_of_tower6.tres"),
	load("res://Currencies/Tower/Knowledge_of_tower7.tres"),
	
	load("res://Currencies/Research/Research.tres"),
	load("res://Currencies/Research/Ticker/Clockwork_Dreamcatcher.tres"),
	load("res://Currencies/Research/Star_Chart.tres"),
	
	load("res://Currencies/Magic/Magic.tres"),
	
	load("res://Currencies/Magic/Lapidamancy/Rules_of_Lapidamancy.tres"),
	load("res://Currencies/Magic/Lapidamancy/Enchanted_Gem.tres"),
	load("res://Currencies/Crystal/Ticker/Gem_Seed.tres"),
	
	load("res://Currencies/Magic/Octomancy/Rules_Of_Octomancy.tres"),
	load("res://Currencies/Magic/Octomancy/Octagon.tres"),
	
	load("res://Currencies/Magic/Calcimancy/Rules_of_Calcimancy.tres"),
	
	load("res://Currencies/Magic/Cyanomancy/Rules_Of_Cyanomancy.tres"),
	load("res://Currencies/Magic/Cyanomancy/Kingly_Blue.tres"),
	
	load("res://Currencies/Magic/Ergomancy/Rules_of_Ergomancy.tres"),
	load("res://Currencies/Magic/Oneiromancy/Rules_of_Oneiromancy.tres"),
	load("res://Currencies/Magic/Thalassomancy/Rules_Thalassomancy.tres"),
	load("res://Currencies/Magic/Apimancy/Rules_of_Apimancy.tres"),
	
	load("res://Currencies/Magic/Mirrormancy/rules_mirrormancy.tres"),
	load("res://Currencies/Magic/Mirrormancy/Runescribed_Mirror.tres"),
	
	load("res://Currencies/Magic/Mage_Locus.tres"),
	load("res://Currencies/Magic/Dream_Locus.tres"),
	
	load("res://Currencies/Mirror/Mirrors.tres"),
	load("res://Currencies/Mirror/Upgrades/Kaleidoscope_Box.tres"),
	load("res://Currencies/Mirror/Ticker/Mirror_Seed.tres"),
	
	load("res://Currencies/Skybound_Alembic/Counters/Azurine_Burner.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Condensing_Coils.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Crystalizing_dish.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Cyanotic_Retort.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Filtration_Gems.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Graduated_Funnel.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Octave_manifold.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Oneiromantic_Aludel.tres"),
	load("res://Currencies/Skybound_Alembic/Counters/Settling_Columns.tres"),
	
	load("res://Currencies/Telescope/Telescope.tres"),
	
	load("res://Currencies/University/University_Access.tres"),
	load("res://Currencies/University/Contributions.tres"),
	load("res://Currencies/University/Outside/Knowledge_outside.tres"),
	load("res://Currencies/University/Inside/Knowledge_inside.tres"),
	load("res://Currencies/University/Offices/Knowledge_offices.tres"),
	load("res://Currencies/University/Offices/Airship_access.tres"),
	load("res://Currencies/University/Offices/Access_Alembic.tres"),
	load("res://Currencies/University/Offices/Access_hive.tres"),
	
	load("res://Currencies/Malachite_Hive/currencies/Flowers.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Honey.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Pollen.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Wax.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Royal_Jelly.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Honey_Frames.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Brood_box.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Comb_Drawer.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Queen_Excluder.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Bee_worker.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Bee_Drone.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Bee_Princess.tres"),
	load("res://Currencies/Malachite_Hive/currencies/Bee_Queen.tres"),
]

func eoc_check() -> bool:
	var visible_currencies = all_currencies.filter(func(obj: Currency): 
		return not obj.is_hidden and not obj.name == "Floor Space" and not obj.name == "Magic" and not obj.name == "Research"
	)
	return visible_currencies.all(func(obj: Currency): 
		return obj.is_full()
	)
	#return CurrencyManager.get_currency("Knowledge: Outside").amount >= 1

func get_currency(currency_name: String):
	var results: Array[Currency] = all_currencies.filter(func(c): return c.name == currency_name)
	return results[0] if results.size() > 0 else null
	
func add_currency(currency_name: String, amount: int):
	var currency = get_currency(currency_name)
	if currency:
		currency.add(amount)

func subtract_currency(currency_name: String, amount: int):
	var currency = get_currency(currency_name)
	if currency: 
		currency.subtract(amount)
	
