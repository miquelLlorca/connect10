extends Control

# Reference to the GridContainer to hold the cells
@onready var grid = $CenterContainer/GridContainer
var main


# Method to populate the table with rows and columns of cells
func populate_table(rows, cols):
	var first_cell_pos

	for row in range(rows):
		for col in range(cols):
			var cell = preload("res://scenes/cell.tscn").instantiate()

			grid.add_child(cell)
			# await get_tree().process_frame
			cell.set_value(round(randf_range(1, 9)))

			var tween = create_tween()
			tween.set_parallel()

			var delay = (row * cols + col) * 0.01
			cell.modulate.a = 0.0
			cell.position = Vector2(0,0)

			tween.tween_property(cell, "position", Vector2(0,0), 0.0001).set_delay(delay)
			tween.tween_property(cell, "position", Vector2(col*64, row*64), 0.2).set_delay(delay)
			tween.tween_property(cell, "modulate:a", 1.0, 0.4).set_delay(delay)


func update_score(points):
	main.update_score(points)



func expand_table():
	if(not main.game_ongoing):
		main.hide_shop_and_missions()
		main.game_ongoing = true
	var values = []
	for i in range(grid.get_child_count()):
		var row = i/10
		var column = i%10
		var cell_value = grid.get_cell_value([row, column])
		if(cell_value!=0):
			values.append(cell_value)

	print(values)
	# for row in range(rows):
	# 	for col in range(cols):	
	for i in range(len(values)):
		var cell = preload("res://scenes/cell.tscn").instantiate()
		grid.add_child(cell)
		cell.set_value(values[i]) 
		var tween = create_tween()
		tween.set_parallel()
		var row = (grid.get_child_count()-1)/10
		var delay = i * 0.04
		cell.modulate.a = 0.0
		cell.position = Vector2(0,0)

		# tween.tween_property(cell, "position", Vector2(0,0), 0.001).set_delay(delay)
		# tween.tween_property(cell, "position", Vector2(col*64, row*64), 0.2).set_delay(delay)
		tween.tween_property(cell, "position:y", 64*row-25, 0.0001).set_delay(delay)
		tween.tween_property(cell, "position:y", 64*row, 0.1).set_delay(delay)
		tween.tween_property(cell, "modulate:a", 1.0, 0.2).set_delay(delay)



func end_run():
	print("end run")

	# resets the table
	var n = grid.get_row_count()
	for i in range(n):
		grid.remove_row(0)
	populate_table(3,10)

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
