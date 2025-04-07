extends Control

var main
var original_colour
@onready var score_button = $HBoxContainer/Score/VBoxContainer/Button
@onready var money_button = $HBoxContainer/Money/VBoxContainer/Button
@onready var max_expand_button = $HBoxContainer/Expands/VBoxContainer/Button

const BASE_PRICE = 10
const BASE_MULTIPLIER = 1
const MAX_EXPAND_LEVEL = 10

func get_price_from_level(level):
	return floor(BASE_PRICE * pow(1.2, level-1))


func get_multiplier_from_level(level):
	return BASE_MULTIPLIER * (1 + level * 0.1)




func upgrade_score_mult():
	var level = main.shop_levels['score']
	var price = get_price_from_level(level)
	print('SCORE')
	print(main.money_available)
	print(level, " ", price)
	if(main.money_available >= price):
		main.shop_levels['score'] += 1;
		main.update_money(-price);
		main.score_multiplier = get_multiplier_from_level(main.shop_levels['score']);
		$HBoxContainer/Score/VBoxContainer/Descr.text = str(round(main.score_multiplier*100.0)/100.0)+"x"
		$HBoxContainer/Score/VBoxContainer/Price.text = str(get_price_from_level(level+1))+"$"
		# setCookieData('shopLevels', shopLevels);
	else:
		print('Not enough money');
		var tween = create_tween()
		tween.tween_property($HBoxContainer/Score, "modulate", Color(1,0,0), 0.25)
		tween.tween_property($HBoxContainer/Score, "modulate", original_colour, 0.25)

func upgrade_money_mult():
	var level = main.shop_levels['money']
	var price = get_price_from_level(level);
	print('MONEY')
	print(main.money_available)
	print(level, " ", price)
	if(main.money_available >= price):
		main.shop_levels['money'] += 1;
		main.update_money(-price);
		main.money_multiplier = get_multiplier_from_level(main.shop_levels['money']);
		$HBoxContainer/Money/VBoxContainer/Descr.text = str(round(main.money_multiplier*100.0)/100.0)+"x"
		$HBoxContainer/Money/VBoxContainer/Price.text = str(get_price_from_level(level+1))+"$"
		# setCookieData('shopLevels', shopLevels);
	else:
		print('Not enough money');
		var tween = create_tween()
		tween.tween_property($HBoxContainer/Money, "modulate", Color(1,0,0), 0.25)
		tween.tween_property($HBoxContainer/Money, "modulate", original_colour, 0.25)

func upgrade_max_expands():
	var level = main.shop_levels['expands']
	var price = get_price_from_level(level)*10;
	print(main.money_available, price)
	if(main.money_available >= price and level<MAX_EXPAND_LEVEL):
		main.shop_levels['expands'] += 1;
		main.update_money(-price);
		main.MAX_EXPANDS += 1
		$HBoxContainer/Expands/VBoxContainer/Descr.text = str(main.MAX_EXPANDS)
		$HBoxContainer/Expands/VBoxContainer/Price.text = str(get_price_from_level(level+1)*10)+"$"
		main.reset_expands()
		# setCookieData('shopLevels', shopLevels);
	else:
		print('Not enough money');
		var tween = create_tween()
		tween.tween_property($HBoxContainer/Expands, "modulate", Color(1,0,0), 0.25)
		tween.tween_property($HBoxContainer/Expands, "modulate", original_colour, 0.25)

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

func _ready() -> void:
	original_colour = $HBoxContainer/Score.modulate 
	main = get_tree().root.get_node("Main")
	score_button.connect("pressed", Callable(self, "upgrade_score_mult"))
	money_button.connect("pressed", Callable(self, "upgrade_money_mult"))
	max_expand_button.connect("pressed", Callable(self, "upgrade_max_expands"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
