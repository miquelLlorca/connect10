extends Control

# Reference to the GridContainer to hold the cells
@onready var grid_container = $GridContainer



# Method to populate the table with rows and columns of cells
func populate_table(rows, cols):
	for row in range(rows):
		for col in range(cols):
			var cell = preload("res://scenes/cell.tscn").instantiate()
			grid_container.add_child(cell)
			cell.set_value(round(randf_range(1, 9)))  


func update_score(points):
	get_parent().update_score(points)

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
