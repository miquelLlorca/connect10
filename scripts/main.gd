extends Control

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
		"upgradesBought":0
	}
var pair_mult = {'11':1,'22':1,'33':1,'44':1,'55':1,'66':1,'77':1,'88':1,'99':1}
var shop_levels = {'score':1, 'money':1, 'expands':1}



var cell_multiplier = 1.0
var row_multiplier = 1.0
var table_multiplier = 1.0
var score_to_money = 1000.0
var mission_money_multiplier = 1.0
var shop_discount = 1.0

var MAX_EXPANDS = 5
var expands_available = MAX_EXPANDS
var score = 0
var money_available = 100
var game_ongoing = false

var score_multiplier = 1
var money_multiplier = 1

@onready var table = $Table
@onready var shop = $Main_V/Shop
@onready var mission_list = $Main_V/MissionList
@onready var score_label = $GridContainer/CenterContainer/Score_Label
@onready var money_label = $GridContainer/CenterContainer2/Money_Label
@onready var expand_button = $GridContainer/CenterContainer3/Expand_Button
@onready var end_run_button = $GridContainer/CenterContainer4/End_Run_Button


func update_score(points):
	if(points<0): # when resetting score mult does not apply
		score += points
	else:
		score += points*score_multiplier
	score_label.text = "Score:\n"+str(score)
	
func update_money(money):
	if(money<0): # when buying mult does not apply
		money_available += money
		statistics['upgradesBought'] += 1
	else:
		money_available += money*money_multiplier
		statistics['totalAmountOfMoney'] += money*money_multiplier
	money_available = round(money_available*100)/100
	money_label.text = "Money:\n"+str(money_available)+"$"
	save_money()

func expand_table():
	if(expands_available>0):
		expands_available -= 1
		expand_button.text = "Expand ("+str(expands_available)+")"
		table.expand_table()

func reset_expands():
	expands_available = MAX_EXPANDS
	expand_button.text = "Expand ("+str(expands_available)+")"

func show_shop_and_missions():
	var tween = create_tween()
	tween.tween_property($Main_V, "position:y", $Main_V.position.y - 1000, 0.25)
	tween.tween_property($Main_V, "modulate:a", 1.0, 0.25)

func hide_shop_and_missions():
	var tween = create_tween()
	tween.tween_property($Main_V, "position:y", $Main_V.position.y + 1000, 0.25)
	tween.tween_property($Main_V, "modulate:a", 0.0, 0.25)


func end_run():	
	if(game_ongoing):
		statistics['gamesPlayed'] += 1
		game_ongoing = false

		# updates data: money, stats...
		var aux = money_available
		update_money(score / score_to_money)
		if(money_available-aux > statistics['maxMoneyInARun']):
			statistics['maxMoneyInARun'] = money_available-aux

		if(score>statistics['highScore']):
			statistics['highScore'] = score

		# resets
		reset_expands()
		update_score(-score)
		table.end_run()

		# save data
		save_stats()
		save_shop_levels()
		save_money()

		# update missions and show them
		mission_list.update_layout()
		show_shop_and_missions()
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
# Data Management

func save_stats():
	var file = FileAccess.open("user://statistics.json", FileAccess.WRITE)
	file.store_string(str(statistics))
	file.close()

func read_stats_file():
	if FileAccess.file_exists("user://statistics.json"):
		var file = FileAccess.open("user://statistics.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		statistics = JSON.parse_string(data)
	else:
		print('Setting up empty stats file')
		save_stats()


func save_money():
	var file = FileAccess.open("user://money.txt", FileAccess.WRITE)
	file.store_string(str(money_available))
	file.close()

func read_money_file():
	if FileAccess.file_exists("user://money.txt"):
		var file = FileAccess.open("user://money.txt", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		money_available = int(data)
	else:
		print('Setting up empty money file')
		save_money()
	money_label.text = "Money:\n"+str(money_available)+"$"


func save_shop_levels():
	var file = FileAccess.open("user://shop_levels.json", FileAccess.WRITE)
	file.store_string(str(shop_levels))
	file.close()

func read_shop_levels_file():
	if FileAccess.file_exists("user://shop_levels.json"):
		var file = FileAccess.open("user://shop_levels.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		shop_levels = JSON.parse_string(data)
	else:
		print('Setting up empty shop levels file')
		save_shop_levels()

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################



# Called when the node enters the scene tree for the first time.
func _ready():

	expand_button.connect("pressed", Callable(self, "expand_table"))
	end_run_button.connect("pressed", Callable(self, "end_run"))
	table.populate_table(3,10)

	# Reset data
	# money_available = 10000
	# save_money()
	# save_shop_levels()
	
	# Read player data
	read_stats_file()
	read_money_file()
	read_shop_levels_file()
	
	print(statistics)

	shop.init_shops()
	reset_expands()

	mission_list.init_missions()
	update_score(0)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
