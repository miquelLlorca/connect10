extends Control

@onready var close_button = $CloseButton


func spawn_circle(table: Control, pos: Vector2):	
	'''
	Spawns circle in the center of the cell.
	Args:
		table (Control): table where the circle should be plotted.
		pos (Vector2): position of the cell.
	'''
	var circle = TextureRect.new()
	circle.set_anchors_preset(Control.PRESET_CENTER)
	circle.texture = preload("res://assets/circle.png")  # Adjust the path as needed
	circle.expand = true
	circle.stretch_mode = TextureRect.STRETCH_SCALE
	circle.pivot_offset = circle.size / 2
	circle.z_index = 100
	circle.size = Vector2(15, 15)
	circle.position = pos  - (circle.size / 2) - Vector2(32,32)  # Center the circle
	circle.modulate = Color(0.1, 0.5, 0.9, 0.9 )  # Blue tint
	table.get_child(0).add_child(circle)


func clear_cell_connector(table: Control, p0: Vector2, p1: Vector2, draw_ends: int):
	''' 
	Plots connector mimicking the clearing cell animation. Circles at the end can be deactivated.
	Args:
		table (Control): table where the connector should be plotted.
		p0 (Vector2): position of first cell.
		p1 (Vector2): position of other cell.
		draw_ends (int): used for specifying which circles to plot {-1:none, 0:p0, 1:p1, 2:both}
	'''
	var start = Vector2(p0[1]*64+32, p0[0]*64+32)
	var end = Vector2(p1[1]*64+32, p1[0]*64+32)
	var line = Line2D.new()
	line.z_index = 100
	line.width = 4
	line.default_color = Color(0.1, 0.5, 0.9, 0.9 )  # Blue tint
	line.points = [start, end]
	table.get_child(0).add_child(line)

	if(draw_ends==0):
		spawn_circle(table, start)
	elif(draw_ends==1):
		spawn_circle(table, end)
	elif(draw_ends==2):
		spawn_circle(table, start)
		spawn_circle(table, end)


func clear_cell_connector_endline(table, pos0, pos1):
	'''
	Starts clear cell animation for endline clearings.
	Args:
		table (Control): table where the connector should be plotted.
		pos0 (Vector2): position of first cell.
		pos1 (Vector2): position of other cell.
	'''
	if(pos0[0]<pos1[0]):
		clear_cell_connector(table, pos0, Vector2(pos0[0],9.4), 0)
		clear_cell_connector(table, Vector2(pos1[0],-0.5), pos1, 1)
	else:
		clear_cell_connector(table, pos1, Vector2(pos1[0],9.4), 0)
		clear_cell_connector(table, Vector2(pos0[0],-0.5), pos0, 1)


##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


func setup_table1():
	'''
	Sets up table 1, example for different directions.
	'''
	var table1_data = [ 4, 1, 7, 7, 9, 2, 
						6, 2, 4, 5, 8, 5]
	var grid1 = GridContainer.new()
	grid1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	grid1.columns = 6
	grid1.position = Vector2(100, 100)
	$Panel/VBoxContainer/Panel.add_child(grid1)

	var CellScene = preload("res://scenes/cell.tscn")
	for number in table1_data:
		var cell = CellScene.instantiate()
		cell.call_deferred("set_value", number, false)
		grid1.add_child(cell)
		
	clear_cell_connector(grid1, Vector2(0,0), Vector2(1,0), 2)	
	clear_cell_connector(grid1, Vector2(0,2), Vector2(0,3), 2)	
	clear_cell_connector(grid1, Vector2(0,5), Vector2(1,4), 2)	
	
	set_mouse_filter_recursive(grid1, Control.MOUSE_FILTER_IGNORE)


func setup_table2():
	'''
	Sets up table 2, example for longer moves.
	'''
	var table2_data = [ 4, 5, 3, 0, 7, 5,
						2, 0, 0, 0, 8, 1]
	var grid2 = GridContainer.new()
	grid2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	grid2.columns = 6
	grid2.position = Vector2(100, 70)
	$Panel/VBoxContainer/Panel2.add_child(grid2)

	var CellScene = preload("res://scenes/cell.tscn")
	for number in table2_data:
		var cell = CellScene.instantiate()
		cell.call_deferred("set_value", number, false)
		grid2.add_child(cell)

	clear_cell_connector(grid2, Vector2(0,2), Vector2(0,4), 2)
	clear_cell_connector(grid2, Vector2(1,0), Vector2(1,4), 2)
	
	set_mouse_filter_recursive(grid2, Control.MOUSE_FILTER_IGNORE)


func setup_table3():
	'''
	Sets up table 3, example for endline moves.
	'''
	var table3_data = [ 4, 5, 9, 0, 0, 0,
						0, 0, 0, 0, 1, 2]
	var grid3 = GridContainer.new()
	grid3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	grid3.columns = 6
	grid3.position = Vector2(100, 70)
	$Panel/VBoxContainer/Panel3.add_child(grid3)

	var CellScene = preload("res://scenes/cell.tscn")
	for number in table3_data:
		var cell = CellScene.instantiate()
		cell.call_deferred("set_value", number, false)
		grid3.add_child(cell)

	# clear_cell_connector_endline(grid3, Vector2(0,2), )
	clear_cell_connector(grid3, Vector2(0, 2), Vector2(0, 5.4), 0)
	clear_cell_connector(grid3, Vector2(1,-0.5), Vector2(1,4), 1)
	
	set_mouse_filter_recursive(grid3, Control.MOUSE_FILTER_IGNORE)


func hide_window():
	self.hide()

func set_mouse_filter_recursive(node: Control, filter_value: int):
	'''
	Sets the mouse filter to a node and all its children.
	Used to disable example tables on tutorial.
	Args:
		node (Control): starting node to edit.
		filter_value (int): value to set on the property.
	'''
	node.mouse_filter = filter_value
	for child in node.get_children():
		if child is Control:
			set_mouse_filter_recursive(child, filter_value)


##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

func _ready() -> void:
	close_button.connect("pressed", Callable(self, "hide_window"))
	setup_table1()
	setup_table2()
	setup_table3()

func _process(delta: float) -> void:
	pass
