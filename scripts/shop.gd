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
	return main.round_to((main.shop_discount * BASE_MULTIPLIER * (1 + (level-1) * 0.1)), 2)


func upgrade_score_mult():
	var level = Data.shop_levels['score']
	var price = get_price_from_level(level)
	if(Data.money_available >= price):
		level += 1
		Data.shop_levels['score'] = level
		main.update_money(-price)
		main.score_multiplier = get_multiplier_from_level(level)
		$HBoxContainer/Score/VBoxContainer/Descr.text = str(get_multiplier_from_level(level+1))+"x"
		$HBoxContainer/Score/VBoxContainer/Price.text = str(get_price_from_level(level))+"$"
		main.save_shop_levels()
	else:
		print('Not enough money');
		var tween = create_tween()
		tween.tween_property($HBoxContainer/Score, "modulate", Color(1,0,0), 0.25)
		tween.tween_property($HBoxContainer/Score, "modulate", original_colour, 0.25)

func upgrade_money_mult():
	var level = Data.shop_levels['money']
	var price = get_price_from_level(level)
	if(Data.money_available >= price):
		level += 1
		Data.shop_levels['money'] = level
		main.update_money(-price)
		main.money_multiplier = get_multiplier_from_level(level)
		$HBoxContainer/Money/VBoxContainer/Descr.text = str(get_multiplier_from_level(level+1))+"x"
		$HBoxContainer/Money/VBoxContainer/Price.text = str(get_price_from_level(level))+"$"
		main.save_shop_levels()
	else:
		print('Not enough money');
		var tween = create_tween()
		tween.tween_property($HBoxContainer/Money, "modulate", Color(1,0,0), 0.25)
		tween.tween_property($HBoxContainer/Money, "modulate", original_colour, 0.25)

func upgrade_max_expands():
	var level = Data.shop_levels['expands']
	var price = get_price_from_level(level)*10
	if(Data.money_available >= price and level<MAX_EXPAND_LEVEL):
		Data.shop_levels['expands'] += 1
		main.update_money(-price)
		main.MAX_EXPANDS += 1
		$HBoxContainer/Expands/VBoxContainer/Descr.text = str(main.MAX_EXPANDS+1)
		$HBoxContainer/Expands/VBoxContainer/Price.text = str(get_price_from_level(level)*10)+"$"
		main.reset_expands()
		main.save_shop_levels()
	else:
		print('Not enough money')
		var tween = create_tween()
		tween.tween_property($HBoxContainer/Expands, "modulate", Color(1,0,0), 0.25)
		tween.tween_property($HBoxContainer/Expands, "modulate", original_colour, 0.25)



func init_shops():
	var level
	level = Data.shop_levels['score'] 
	main.score_multiplier = get_multiplier_from_level(level);
	$HBoxContainer/Score/VBoxContainer/Descr.text = str(get_multiplier_from_level(level+1))+"x"
	$HBoxContainer/Score/VBoxContainer/Price.text = str(get_price_from_level(level))+"$"
	
	level = Data.shop_levels['money'] 
	main.money_multiplier = get_multiplier_from_level(level);
	$HBoxContainer/Money/VBoxContainer/Descr.text = str(get_multiplier_from_level(level+1))+"x"
	$HBoxContainer/Money/VBoxContainer/Price.text = str(get_price_from_level(level))+"$"

	level = Data.shop_levels['expands'] 
	for i in range(1,level):
		main.MAX_EXPANDS += 1
	$HBoxContainer/Expands/VBoxContainer/Descr.text = str(main.MAX_EXPANDS+1)
	$HBoxContainer/Expands/VBoxContainer/Price.text = str(get_price_from_level(level)*10)+"$"
		
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
