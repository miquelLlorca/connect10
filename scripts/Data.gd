extends Node
var main

var statistics = {
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
var shop_levels = {'score':1, 'money':1, 'expands':1}
var money_available = 0



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
	else:
		print('Setting up empty stats file')
		save_stats()

func read_money_file():
	if FileAccess.file_exists("user://money.txt"):
		var file = FileAccess.open("user://money.txt", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		money_available = int(data)
	else:
		print('Setting up empty money file')
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
		save_shop_levels()

func init_data():
	read_stats_file()
	read_money_file()
	read_shop_levels_file()

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


func reset_data():
	money_available = 0
	statistics = {
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
	shop_levels = {'score':1, 'money':1, 'expands':1}


	save_money()
	save_shop_levels()
	save_stats()




func _ready():
	main = get_tree().root.get_node("Main")