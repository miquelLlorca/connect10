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

func get_table_values(keep_zeros):
	'''
	Keep zeros indicates if the empty spaces should be added to the list as 0s
	'''
	var values = []
	for i in range(grid.get_child_count()):
		var row = i/10
		var column = i%10
		var cell_value = grid.get_cell_value([row, column])
		if(cell_value!=0 or keep_zeros):
			values.append(cell_value)
	return values

func populate_table_with_list(values, keep_zeros):
	for i in range(len(values)):
		if(values[i]!=0 or keep_zeros):
			var cell = preload("res://scenes/cell.tscn").instantiate()
			grid.add_child(cell)
			cell.set_value(values[i])
			
			var tween = create_tween()
			tween.set_parallel()
			var row = (grid.get_child_count()-1)/10
			var delay = i * 0.04
			cell.modulate.a = 0.0
			cell.position = Vector2(0,0)

			tween.tween_property(cell, "position:y", 64*row-25, 0.0001).set_delay(delay)
			tween.tween_property(cell, "position:y", 64*row, 0.1).set_delay(delay)
			tween.tween_property(cell, "modulate:a", 1.0, 0.2).set_delay(delay)

func expand_table():
	if(not main.game_ongoing):
		main.hide_shop_and_missions()
		main.game_ongoing = true

	var keep_zeros = false
	var values = get_table_values(keep_zeros)
	populate_table_with_list(values, keep_zeros)
	Data.save_game_state()

func end_run():
	# resets the table
	var n = grid.get_row_count()
	for i in range(n-1,-1,-1):
		await grid.remove_row(i)
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
