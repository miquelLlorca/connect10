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
