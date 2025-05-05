extends Control



# mission rewards
var pair_mult = {'11':1,'22':1,'33':1,'44':1,'55':1,'66':1,'77':1,'88':1,'99':1}
var cell_multiplier = 1.0
var row_multiplier = 1.0
var table_multiplier = 1.0
var score_to_money = 1000.0
var mission_money_multiplier = 1.0
var shop_discount = 1.0
var sum_10_mult = 1
var distance_multiplier = 1

var MAX_EXPANDS = 5
var expands_available = MAX_EXPANDS
var score = 0
var game_ongoing = false

var score_multiplier = 1
var money_multiplier = 1

# @onready var admob = Engine.get_singleton("AdMob")

@onready var table = $Table
@onready var shop = $Main_V/Shop
@onready var mission_list = $Main_V/MissionList
@onready var score_label = $GridContainer/CenterContainer/Score_Label
@onready var money_label = $GridContainer/CenterContainer2/Money_Label
@onready var expand_button = $GridContainer/CenterContainer3/Expand_Button
@onready var end_run_button = $GridContainer/CenterContainer4/End_Run_Button
@onready var settings_button = $Settings
var settings_window: Control

func round_to(x, n):
	return round(x*10.0**n)/10.0**n

func set_score(points):
	score = points
	score = round_to(score, 2)
	score_label.text = "Score:\n"+str(score)

func show_score_diff(amount: float, origin_pos: Vector2):
	origin_pos = origin_pos + Vector2(10, +45)
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.z_index = 100
	panel.position = origin_pos
	add_child(panel)

	# Set style with rounded corners and color
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0.75, 0, 0.8) if (amount >= 0) else Color(0.75, 0, 0, 0.8)
	stylebox.corner_radius_top_left = 10
	stylebox.corner_radius_top_right = 10
	stylebox.corner_radius_bottom_left = 10
	stylebox.corner_radius_bottom_right = 10
	stylebox.corner_detail = 4  # Optional: smoother corners
	panel.add_theme_stylebox_override("panel", stylebox)

	var label = Label.new()
	label.text = " " + str(amount)
	label.add_theme_color_override("font_color", Color(1, 1, 1))

	var label_settings = LabelSettings.new()
	label_settings.font_size = 30
	label.label_settings = label_settings

	label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.add_child(label)

	await get_tree().process_frame
	panel.size = label.get_minimum_size() + Vector2(10, 6)

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(panel, "position", origin_pos + Vector2(0, -50), 1)
	tween.tween_property(panel, "modulate:a", 0.0, 1)
	tween.tween_callback(Callable(panel, "queue_free")).set_delay(2)

func update_score(points):
	var diff = points*score_multiplier
	score = round_to(score + diff,2)
	score_label.text = "Score:\n"+str(score)
	show_score_diff(diff, score_label.global_position)

func show_money_diff(amount: float, origin_pos: Vector2):
	print(amount)
	origin_pos = origin_pos + Vector2(10, +45)
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.z_index = 100
	panel.position = origin_pos
	add_child(panel)

	# Set style with rounded corners and color
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0.75, 0, 0.8) if (amount >= 0) else Color(0.75, 0, 0, 0.8)
	stylebox.corner_radius_top_left = 10
	stylebox.corner_radius_top_right = 10
	stylebox.corner_radius_bottom_left = 10
	stylebox.corner_radius_bottom_right = 10
	stylebox.corner_detail = 4  # Optional: smoother corners
	panel.add_theme_stylebox_override("panel", stylebox)

	var label = Label.new()
	label.text = " " + str(amount) + " $"
	label.add_theme_color_override("font_color", Color(1, 1, 1))

	var label_settings = LabelSettings.new()
	label_settings.font_size = 30
	label.label_settings = label_settings

	label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.add_child(label)

	await get_tree().process_frame
	panel.size = label.get_minimum_size() + Vector2(10, 6)

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(panel, "position", origin_pos + Vector2(0, -50), 3)
	tween.tween_property(panel, "modulate:a", 0.0, 3)
	tween.tween_callback(Callable(panel, "queue_free")).set_delay(2)

func update_money(money):
	var diff
	if(money<0): # when buying mult does not apply
		diff = round_to(money,2)	
		Data.money_available += diff
		Data.statistics['upgradesBought'] += 1
	else:
		diff = round_to(money*money_multiplier,2)
		Data.money_available += diff
		Data.statistics['totalAmountOfMoney'] += diff
		Data.statistics['totalAmountOfMoney'] = round_to(Data.statistics['totalAmountOfMoney'], 2)
	Data.money_available = round_to(Data.money_available, 2)
	money_label.text = "Money:\n"+str(Data.money_available)+"$"
	show_money_diff(diff, money_label.global_position)
	Data.save_money()

func show_settings():
	var screen_size = get_viewport_rect().size
	var window_size = settings_window.size
	settings_window.position = (screen_size - window_size) / 2
	settings_window.show()

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
		Data.statistics['gamesPlayed'] += 1
		game_ongoing = false

		# updates data: money, stats...
		var aux = Data.money_available
		update_money(mission_money_multiplier * score / score_to_money)
		if(Data.money_available-aux > Data.statistics['maxMoneyInARun']):
			Data.statistics['maxMoneyInARun'] = Data.money_available-aux

		if(score>Data.statistics['highScore']):
			Data.statistics['highScore'] = score

		# resets
		reset_expands()
		set_score(0)
		table.end_run()

		# save data
		Data.save_stats()
		Data.save_shop_levels()
		Data.save_money()
		Data.clear_game_state()

		# update missions and shop and show them
		mission_list.update_layout()
		shop.render_shops()
		show_shop_and_missions()


##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

func init_main():
	Data.init_data()
	print(Data.statistics)
	mission_list.init_missions()
	await mission_list.missions_ready
	shop.init_shops()
	reset_expands()
	
	if(Data.game_state != null):
		table.populate_table_with_list(Data.game_state['table'], true)
		set_score(Data.game_state['score'])
		expands_available = Data.game_state['expands_available']
		expand_button.text = "Expand ("+str(expands_available)+")"
		game_ongoing = true
		hide_shop_and_missions()
	else:
		table.populate_table(3,10)
		set_score(0)
	
		if(game_ongoing):
			# this can only be accesed by a reset coming from an ongoing game
			show_shop_and_missions()

# Called when the node enters the scene tree for the first time.
func _ready():

	settings_button.connect("pressed", Callable(self, "show_settings"))
	expand_button.connect("pressed", Callable(self, "expand_table"))
	end_run_button.connect("pressed", Callable(self, "end_run"))
	
	settings_window = preload("res://scenes/settings.tscn").instantiate()
	add_child(settings_window)
	settings_window.hide()
	init_main()
	# admob.init('ca-app-pub-9221900563273591~4549362904')
	# admob.load_banner('ca-app-pub-3940256099942544/9214589741', true)
	# admob.set_banner_position(admob.BANNER_BOTTOM)
	# await get_tree().create_timer(1.0).timeout
	# admob.show_banner()
	# '''
	# APP ID:
	# 	ca-app-pub-9221900563273591~4549362904
	# BANNER inf ID:
	# 	ca-app-pub-9221900563273591/8219054725
		
	# IDS TESTING
	# Banner: ca-app-pub-3940256099942544/9214589741
	# '''




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
