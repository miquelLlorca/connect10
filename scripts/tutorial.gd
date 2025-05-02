extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var table1_data = [4, 0, 7, 3, 0, 2, 6, 0, 0, 0, 8, 0]
	var grid = GridContainer.new()
	grid.columns = 6
	grid.position = Vector2(100, 100)
	$Panel/VBoxContainer/Panel.add_child(grid)

	var CellScene = preload("res://scenes/cell.tscn")
	for number in table1_data:
		var cell = CellScene.instantiate()
		cell.call_deferred("set_value", number)  # Assumes Cell.gd has an exported 'value' var
		grid.add_child(cell)
		
		
	
	var table2_data = [4,5,3,0,0,0,0,0,0,0,7,1]
	grid = GridContainer.new()
	grid.columns = 6
	grid.position = Vector2(100, 70)
	$Panel/VBoxContainer/Panel3.add_child(grid)

	CellScene = preload("res://scenes/cell.tscn")
	for number in table2_data:
		var cell = CellScene.instantiate()
		cell.call_deferred("set_value", number)  # Assumes Cell.gd has an exported 'value' var
		grid.add_child(cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
