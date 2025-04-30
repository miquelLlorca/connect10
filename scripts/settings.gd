extends Panel

@onready var close_button = $CloseButton
@onready var reset_button = $ResetButton
var main

func hide_window():
	self.hide()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")
	close_button.connect("pressed", Callable(self, "hide_window"))
	reset_button.connect("pressed", Callable(main, "reset_data"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
