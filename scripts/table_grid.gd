extends GridContainer


var pos0
var pos1
var main
var initColumns = 10
var initRows = 3


func get_cell(pos):
	var i = pos[0]*10 + pos[1]
	return get_child(i)
	
func get_cell_value(pos):
	var i = pos[0]*10 + pos[1]
	if(i>=self.get_child_count()):
		return 0 # trying to read at the right of an unfinished line
	var value = get_child(i).cell_value
	if(typeof(value)==TYPE_STRING and value==""):
			return 0
	return int(value)



##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


func _on_cell_click(row, column):
	if(not pos0):
		pos0 = [row, column]
		get_cell(pos0).set_colour()
	elif(not (pos0[0]==row and pos0[1]==column)):
		pos1 = [row, column]
		print(pos0, " -> ", pos1)
		print(get_cell_value(pos0))
		print(get_cell_value(pos1))
		
		if(execute_movement()):
			get_cell(pos0).set_value("")
			get_cell(pos1).set_value("")
			if(not main.game_ongoing):
				main.hide_shop_and_missions()
				main.game_ongoing = true
			print('CORRECT')
		else:
			print('INCORRECT')
		get_cell(pos0).clean_colour()
		clear_empty_rows();
		pos0 = null
		pos1 = null

func get_row_count():
	return ceil(float(self.get_child_count()) / columns)
	
func remove_row(row):
	var start_index = row * columns  

	for i in range(columns):
		if(start_index < self.get_child_count()):
			var cell = self.get_child(start_index)
			self.remove_child(cell)
			cell.queue_free()
	# Optionally, refresh the grid layout to avoid gaps
	self.queue_sort()

func get_incr(diff):
		if(diff > 0):
			return -1
		if(diff < 0):
			return +1
		return 0

func check_mid_line_empty(pos, dir):
	if(dir == 1):
		for i in range(pos[1]+1, initColumns):

			if(get_cell_value([pos[0], i]) != 0):
				return false
		return true;
	else:
		for i in range(pos[1] - 1, -1, -1):
			if(get_cell_value([pos[0], i]) != 0):
				return false;
		return true;

func clear_empty_rows():
	var empty0 = check_mid_line_empty([pos0[0],-1],1)

	if(empty0):
		remove_row(pos0[0])
		main.update_score(100)
		# statistics.rowsCleared+=1
	
	if(empty0 && pos1[0]>pos0[0]):
		pos0[0] = pos0[0]-1
		pos1[0] = pos1[0]-1

	if(pos0[0]!=pos1[0]):
		var empty1 = check_mid_line_empty([pos1[0],-1],1)
		if(empty1):
			remove_row(pos1[0])
			main.update_score(100);
			# statistics.rowsCleared+=1


	if(get_row_count()==0):
		main.update_score(1000);
		# statistics.tablesCleared+=1;
		main.reset_expands()
		# expandsLeft = maxExpands;
		# initTable();
		get_parent().get_parent().populate_table(3,10);

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################



func execute_movement():
	# Are the numbers compatible? Numbers must be equal or sum 10
	var n0 = get_cell_value(pos0)
	var n1 = get_cell_value(pos1)
	if(not ((n0==n1) or (n0+n1==10))):
		print('not compatible numbers')
		return false;
	
	# Is the move horizontal, vertical or diagonal?
	var dx = pos0[0]-pos1[0];
	var dy = pos0[1]-pos1[1];
	
	# if   Horizontal	 or	  vertical	  or	  diagonal
	if((pos0[0]==pos1[0]) || (pos0[1]==pos1[1]) || (abs(dx)==abs(dy))):
		# iterates direct path between selections
		var x = pos0[0]
		var y = pos0[1]
		var incrX = get_incr(dx)
		var incrY = get_incr(dy)
		var i=0
		var j=0

		while(true):
			i += incrX; j += incrY
			if(pos1[0]==x+i && pos1[1]==y+j):
				# gets to the other pos without finding a number
				break
		
			if(get_cell_value([x+i, y+j])!=0):
				# a number in the middle makes move not valid
				print("number in the middle")
				return false

		main.update_score(get_cell_value(pos0)+get_cell_value(pos1))
		return true;
	else:
		# Possible Endline move needs different treatment.
		if(abs(dx)>1):
			# impossible because this move only works for the next row
			print("endline not possible too many rows")
			return false
		
		var right
		var left
		if(dx==1):
			right = check_mid_line_empty(pos0, -1)
			left =  check_mid_line_empty(pos1, 1)
		else:
			right = check_mid_line_empty(pos1, -1)
			left =  check_mid_line_empty(pos0, 1)
	
		if(left and right):
			main.update_score(
				2*(get_cell_value(pos0)+get_cell_value(pos1))
			)
			return true;
		else:
			print("endline not possible line with numbers")
			return false;
		






##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")
	print(main)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
