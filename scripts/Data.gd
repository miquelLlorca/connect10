extends Node
var main

var statistics
var shop_levels
var money_available = 0

var default_statistics = {
		"cellsCleared":0,
		"rowsCleared":0,
		"tablesCleared":0,
		"gamesPlayed":0,
		"sum10s":0,
		"pairs":{
			"11":0,
			"22":0,
			"33":0,
			"44":0,
			"55":0,
			"66":0,
			"77":0,
			"88":0,
			"99":0
		},
		"highScore":0,
		"totalAmountOfMoney":0,
		"maxMoneyInARun":0,
		"upgradesBought":0,
		"maxDistance":0
	}
var default_shop_levels = {'score':1, 'money':1, 'expands':1}
var game_state = null


##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
# SAVE DATA
func save_stats():
	var file = FileAccess.open("user://statistics.json", FileAccess.WRITE)
	file.store_string(str(statistics))
	file.close()

func save_money():
	var file = FileAccess.open("user://money.txt", FileAccess.WRITE)
	file.store_string(str(money_available))
	file.close()

func save_shop_levels():
	var file = FileAccess.open("user://shop_levels.json", FileAccess.WRITE)
	file.store_string(str(shop_levels))
	file.close()

func save_game_state():
	game_state = {
		"score": main.score,
		"expands_available": main.expands_available,
		"table": main.table.get_table_values(true)
	}
	var file = FileAccess.open("user://game_state.json", FileAccess.WRITE)
	file.store_string(str(game_state))
	file.close()

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
# READ DATA
func read_stats_file():
	if FileAccess.file_exists("user://statistics.json"):
		var file = FileAccess.open("user://statistics.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		statistics = JSON.parse_string(data)
		# future-proofing for new stats added
		var default_keys = default_statistics.keys()
		var saved_keys = statistics.keys()
		var missing_keys = default_keys.filter(func(k): return not saved_keys.has(k))
		if(len(missing_keys)>0):
			for key in missing_keys:
				statistics[key] = default_statistics[key]
			save_stats()
	else:
		print('Setting up empty stats file')
		statistics = default_statistics.duplicate(true)
		save_stats()

func read_money_file():
	if FileAccess.file_exists("user://money.txt"):
		var file = FileAccess.open("user://money.txt", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		money_available = int(data)
	else:
		print('Setting up empty money file')
		money_available = 0
		save_money()
	main.money_label.text = "Money:\n"+str(money_available)+"$"

func read_shop_levels_file():
	if FileAccess.file_exists("user://shop_levels.json"):
		var file = FileAccess.open("user://shop_levels.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		shop_levels = JSON.parse_string(data)
	else:
		print('Setting up empty shop levels file')
		shop_levels = default_shop_levels.duplicate(true)
		save_shop_levels()

func read_game_state_file():
	if FileAccess.file_exists("user://game_state.json"):
		var file = FileAccess.open("user://game_state.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		game_state = JSON.parse_string(data)
	
func init_data():
	read_stats_file()
	read_money_file()
	read_shop_levels_file()
	read_game_state_file()

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
# Other

func remove_file(path):
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func clear_game_state():
	remove_file('user://game_state.json')

func reset_data():
	money_available = 0
	statistics = default_statistics.duplicate(true)
	shop_levels = default_shop_levels.duplicate(true)
	game_state = null
	clear_game_state()
	save_money()
	save_shop_levels()
	save_stats()


func _ready():
	main = get_tree().root.get_node("Main")
