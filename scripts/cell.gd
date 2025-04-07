extends Panel

var parentPos
var original_colour
var cell_value = 0
@onready var label = $Label  # This will access the 'NumberLabel' child node

var cell_width = 50  # Set your cell width
var cell_height = 50  # Set your cell height
	
func set_value(value):
	cell_value = value
	label.text = str(cell_value)  # Update the label with the new number.

func set_colour():
	self.modulate = Color(0.1, 0.5, 0.9)  # RGB for red

func clean_colour():
	self.modulate = original_colour
	
func _on_cell_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var column = int((position.x-parentPos.x) / cell_width)
		var row = int((position.y-parentPos.y) / cell_height)
		print("Cell clicked at: ", self.position, " -> ", row, ",", column) 
		get_parent()._on_cell_click(row, column)
		
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	# gets the pos of the center container as when the table is resetted the position gets messed up
	parentPos = get_parent().get_parent().position
	original_colour = self.modulate
	self.connect("gui_input", _on_cell_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
