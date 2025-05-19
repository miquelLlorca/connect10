extends Panel

@onready var close_button = $HBoxContainer/CloseButton
@onready var mute_button = $HBoxContainer/MuteButton
@onready var help_button = $HBoxContainer/HelpButton
@onready var reset_button = $VBoxContainer/ResetButton
var main
var tutorial_window

func hide_window():
	self.hide()

func _on_reset_pressed():
	$ResetConfirmDialog.popup_centered()

func _on_help_pressed():
	tutorial_window.show()

func _on_reset_confirmed():
	Data.reset_data()
	main.pair_mult = {'11':1,'22':1,'33':1,'44':1,'55':1,'66':1,'77':1,'88':1,'99':1}
	main.cell_multiplier = 1.0
	main.row_multiplier = 1.0
	main.table_multiplier = 1.0
	main.score_to_money = 1000.0
	main.mission_money_multiplier = 1.0
	main.shop_discount = 1.0
	main.sum_10_mult = 1
	main.distance_multiplier = 1

	self.hide()
	main.hide_shop_and_missions()
	var n = main.table.grid.get_row_count()
	for i in range(n-1,-1,-1):
		await main.table.grid.remove_row(i)
	main.init_main()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")
	close_button.connect("pressed", Callable(self, "hide_window"))
	help_button.connect("pressed", Callable(self, "_on_help_pressed"))
	# reset_button.connect("pressed", Callable(Data, "reset_data"))
	reset_button.connect("pressed", Callable(self, "_on_reset_pressed"))
	$ResetConfirmDialog.connect("confirmed", Callable(self, "_on_reset_confirmed"))

	tutorial_window = preload("res://scenes/tutorial_window.tscn").instantiate()
	main.add_child(tutorial_window)
	# tutorial_window.set_anchors_preset(Control.PRESET_TOP_LEFT)
	tutorial_window.set_anchors_preset(Control.PRESET_FULL_RECT)
	tutorial_window.global_position = Vector2(0,0)
	# tutorial_window.margin_left = 0
	# tutorial_window.margin_top = 0
	tutorial_window.hide()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
