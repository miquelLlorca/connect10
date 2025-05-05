extends Panel

@onready var close_button = $CloseButton
@onready var reset_button = $VBoxContainer/ResetButton
var main

func hide_window():
	self.hide()

func _on_reset_pressed():
	$ResetConfirmDialog.popup_centered()

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
	var n = main.table.grid.get_row_count()
	for i in range(n):
		main.table.grid.remove_row(0)
	main.init_main()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")
	close_button.connect("pressed", Callable(self, "hide_window"))
	# reset_button.connect("pressed", Callable(Data, "reset_data"))
	reset_button.connect("pressed", Callable(self, "_on_reset_pressed"))
	$ResetConfirmDialog.connect("confirmed", Callable(self, "_on_reset_confirmed"))




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
