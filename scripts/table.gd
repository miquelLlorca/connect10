extends Control

# Reference to the GridContainer to hold the cells
@onready var grid = $CenterContainer/GridContainer
var main
const MAX_TABLE_LENGTH=120

func populate_table(rows: int, cols: int):
	'''
	Populates the table with random numbers given a certain size.
	Args:
		rows (int): number of rows.
		cols (int): number of cols.
	'''
	for row in range(rows):
		for col in range(cols):
			var cell = preload("res://scenes/cell.tscn").instantiate()

			grid.add_child(cell)
			# await get_tree().process_frame
			cell.set_value(round(randf_range(1, 9)), false)

			var tween = create_tween()
			tween.set_parallel()

			var delay = (row * cols + col) * 0.01
			cell.modulate.a = 0.0
			cell.position = Vector2(0,0)

			tween.tween_property(cell, "position", Vector2(0,0), 0.0001).set_delay(delay)
			tween.tween_property(cell, "position", Vector2(col*64, row*64), 0.2).set_delay(delay)
			tween.tween_property(cell, "modulate:a", 1.0, 0.4).set_delay(delay)

func get_table_values(keep_zeros: bool):
	'''
	Gets the values on the table for expanding or saving table state.
	Args:
		keep_zeros (bool): indicates if the empty spaces should be added to the list as 0s or skipped.
	Returns:
		array[int]: the numbers on the table.
	'''
	var values = []
	for i in range(grid.get_child_count()):
		var row = i/10
		var column = i%10
		var cell_value = grid.get_cell_value([row, column])
		if(cell_value!=0 or keep_zeros):
			values.append(cell_value)
	return values

func populate_table_with_list(values: Array, keep_zeros: bool):
	'''
	Populates the table using a given list of numbers.
	Args:
		values (array[int]): the values to be written in the table.
		keep_zeros (bool): specifies if the zeros in the list should be skipped when populating table.
	'''
	if(not keep_zeros):
		values = values.filter(func(x): return x != 0)

	for i in range(len(values)):
		if(grid.get_child_count()<MAX_TABLE_LENGTH):
			var cell = preload("res://scenes/cell.tscn").instantiate()
			grid.add_child(cell)
			cell.set_value(values[i], false)
			
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
	'''
	Expands the table, does not keep zeros.
	'''
	if(not main.game_ongoing):
		main.hide_shop_and_missions()

	if(grid.pos0 != null):
		grid.get_cell(grid.pos0).deselect_cell()
		grid.pos0 = null

	var keep_zeros = true
	var values = get_table_values(keep_zeros)
	if(len(values)<MAX_TABLE_LENGTH):
		keep_zeros = false
		populate_table_with_list(values, keep_zeros)
		Data.save_game_state()
		return true
	return false

func end_run():
	'''
	When run is ended, all table is cleared and populated randomly again.
	'''
	var n = grid.get_row_count()
	for i in range(n-1,-1,-1):
		await grid.remove_row(i)
	populate_table(3,10)

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

func _ready() -> void:
	main = get_tree().root.get_node("Main")


func _process(delta: float) -> void:
	pass
