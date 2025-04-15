extends Control

var statistics
var cell_multiplier
var row_multiplier
var table_multiplier
var score_to_money



var MAX_EXPANDS = 5
var expands_available = MAX_EXPANDS
var score = 0
var money_available = 100
var game_ongoing = false

var score_multiplier = 1
var money_multiplier = 1
var shop_levels = {'score':1, 'money':1, 'expands':1}

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
	money_label.text = "Money:\n"+str(money_available)+"$"

func expand_table():
	if(expands_available>0):
		print(expands_available)
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
		update_money(score / 1000.0)
		if(money_available-aux > statistics['maxMoneyInARun']):
			statistics['maxMoneyInARun'] = money_available-aux

		if(score>statistics['highScore']):
			statistics['highScore'] = score
		# checks missions

		# resets
		reset_expands()
		update_score(-score)
		
		table.end_run()
		save_stats()
		show_shop_and_missions()
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
# Data Management

func set_default_stats():
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
		"upgradesBought":0
	}

func save_stats():
	var file = FileAccess.open("user://statistics.json", FileAccess.WRITE)
	file.store_string(str(statistics))
	print(str(statistics))
	file.close()

func read_stats_file():
	if FileAccess.file_exists("user://statistics.json"):
		var file = FileAccess.open("user://statistics.json", FileAccess.READ)
		var data = file.get_as_text()
		file.close()
		statistics = JSON.parse_string(data)
	else:
		print('Setting up empty stats file')
		set_default_stats()
		save_stats()



##########################################################################################################################
##########################################################################################################################
##########################################################################################################################



# Called when the node enters the scene tree for the first time.
func _ready():

	expand_button.text = "Expand ("+str(expands_available)+")"
	expand_button.connect("pressed", Callable(self, "expand_table"))
	end_run_button.connect("pressed", Callable(self, "end_run"))
	table.populate_table(3,10)
	# set_default_stats()
	# save_stats()
	read_stats_file()
	print(statistics)
	mission_list.init_missions()
	update_money(0) #! will read from saved data
	update_score(0)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
