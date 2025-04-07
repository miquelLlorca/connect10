extends Control

const MAX_EXPANDS = 5
var expands_available = MAX_EXPANDS
var score = 0
var money_available = 0
var game_ongoing = false
@onready var table = $Main_V/Table
@onready var shop = $Main_V/Shop
@onready var score_label = $GridContainer/CenterContainer/Score_Label
@onready var money_label = $GridContainer/CenterContainer2/Money_Label
@onready var expand_button = $GridContainer/CenterContainer3/Expand_Button
@onready var end_run_button = $GridContainer/CenterContainer4/End_Run_Button


func update_score(points):
	score += points
	score_label.text = "Score:\n"+str(score)
	
func update_money(money):
	money_available += money
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
	tween.tween_property(shop, "position:y", shop.position.y - 1000, 0.5)  # Slide down
	tween.tween_property(shop, "modulate:a", 1.0, 0.25)

func hide_shop_and_missions():
	var tween = create_tween()
	tween.tween_property(shop, "position:y", shop.position.y + 1000, 0.5)  # Slide down
	tween.tween_property(shop, "modulate:a", 0.0, 0.25)

func end_run():	
	# updates data: money, stats...
	update_money(score / 1000.0)

	# checks missions

	reset_expands()
	update_score(-score)
	
	table.end_run()
	show_shop_and_missions()
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	update_money(0) #! will read from saved data
	update_score(0)

	expand_button.text = "Expand ("+str(expands_available)+")"
	expand_button.connect("pressed", Callable(self, "expand_table"))
	end_run_button.connect("pressed", Callable(self, "end_run"))
	table.populate_table(3,10) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
