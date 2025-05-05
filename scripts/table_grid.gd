extends GridContainer


var pos0
var pos1
var main
var initColumns = 10
var initRows = 3

const CLEAR_CELLS_ANIMATION_DURATION = 0.3

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

func spawn_circle(pos: Vector2):
	var circle = TextureRect.new()
	circle.set_anchors_preset(Control.PRESET_CENTER)
	circle.texture = preload("res://assets/circle.png")  # Adjust the path as needed
	circle.expand = true
	circle.stretch_mode = TextureRect.STRETCH_SCALE
	circle.pivot_offset = circle.size / 2
	# circle.z_index = 100
	circle.size = Vector2(20, 20)
	circle.position = pos  - (circle.size / 2)  # Center the circle
	circle.modulate = Color(0.1, 0.5, 0.9, 1 )  # Blue tint

	main.add_child(circle)
	var tween = create_tween()
	tween.set_parallel()

	var scale_target = Vector2(0.1, 0.1)
	var duration = CLEAR_CELLS_ANIMATION_DURATION
	var initial_size = circle.size
	var delta_size = initial_size * (scale_target - Vector2.ONE)

	tween.tween_property(circle, "scale", scale_target, duration)
	tween.tween_property(circle, "position", circle.position - (delta_size / 2), duration)
	tween.tween_property(circle, "modulate:a", 0.0, duration)
	tween.tween_callback(Callable(circle, "queue_free")).set_delay(1)



func clear_cell_animation(p0, p1, draw_ends):
	''' 
	Draw ends {-1:none, 0:p0, 1:p1, 2:both}
	'''
	var x = self.get_global_rect().position.x
	var y = self.get_global_rect().position.y
	var start = Vector2(x+p0[1]*64+32, y+p0[0]*64+32)
	var end = Vector2(x+p1[1]*64+32, y+p1[0]*64+32)
	var line = Line2D.new()
	line.width = 4
	line.default_color = Color(0.1, 0.5, 0.9, 1 )  # Blue tint
	line.points = [start, end]
	main.add_child(line)

	if(draw_ends==0):
		spawn_circle(start)
	elif(draw_ends==1):
		spawn_circle(end)
	elif(draw_ends==2):
		spawn_circle(start)
		spawn_circle(end)

	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 0.0, CLEAR_CELLS_ANIMATION_DURATION)
	tween.tween_callback(Callable(line, "queue_free")).set_delay(1)


func clear_cell_animation_endline():
	if(pos0[0]<pos1[0]):
		clear_cell_animation(pos0, Vector2(pos0[0],9.4), 0)
		clear_cell_animation(Vector2(pos1[0],-0.5), pos1, 1)
	else:
		clear_cell_animation(pos1, Vector2(pos1[0],9.4), 0)
		clear_cell_animation(Vector2(pos0[0],-0.5), pos0, 1)

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


func _on_cell_click(row, column):
	if(not pos0):
		pos0 = [row, column]
		get_cell(pos0).set_colour()
	elif(not (pos0[0]==row and pos0[1]==column)):
		pos1 = [row, column]
		var n0 = get_cell_value(pos0)
		var n1 = get_cell_value(pos1)
		get_cell(pos0).clean_colour()
		
		if(execute_movement()):
			get_cell(pos0).set_value(0)
			get_cell(pos1).set_value(0)
			if(not main.game_ongoing):
				main.hide_shop_and_missions()
				main.game_ongoing = true
			Data.statistics['cellsCleared'] += 2
			if(n0==n1):
				Data.statistics['pairs'][str(n0)+str(n0)] += 1
			else:
				Data.statistics['sum10s'] += 1
			print('CORRECT')
			await clear_empty_rows()
			Data.save_game_state()
		else:
			print('INCORRECT')

		pos0 = null
		pos1 = null

func get_row_count():
	return ceil(float(self.get_child_count()) / columns)
	
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
		

func remove_row(row):
	var start_index = row * columns  

	for i in range(columns):
		var cell = self.get_child(start_index+i)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(cell, "position:x", 0, 0.2)
		tween.tween_property(cell, "modulate:a", 0.0, 0.2)
		tween.tween_callback(Callable(cell, "queue_free")).set_delay(0.2)
	await get_tree().create_timer(0.2).timeout  # Wait for the animation to finish
	self.queue_sort()

func clear_empty_rows():
	var empty0 = check_mid_line_empty([pos0[0],-1],1)

	if(empty0):
		await remove_row(pos0[0])
		main.update_score(100*main.row_multiplier)
		Data.statistics['rowsCleared'] += 1

	if(empty0 && pos1[0]>pos0[0]):
		pos0[0] = pos0[0]-1
		pos1[0] = pos1[0]-1

	if(pos0[0]!=pos1[0]):
		var empty1 = check_mid_line_empty([pos1[0],-1],1)
		if(empty1):
			await remove_row(pos1[0])
			main.update_score(100*main.row_multiplier);
			Data.statistics['rowsCleared'] += 1


	if(get_row_count()==0):
		main.update_score(1000*main.table_multiplier*main.expands_available+1);
		Data.statistics['tablesCleared'] += 1
		main.reset_expands()
		get_parent().get_parent().populate_table(3,10);

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################



func execute_movement():
	# Are the numbers compatible? Numbers must be equal or sum 10
	var n0 = get_cell_value(pos0)
	var n1 = get_cell_value(pos1)
	if(not ((n0==n1) or (n0+n1==10)) or ((n0==0) or (n1==0))):
		return false;
	
	# Is the move horizontal, vertical or diagonal?
	var dx = pos0[0]-pos1[0];
	var dy = pos0[1]-pos1[1];
	
	# if   Horizontal	  or	  vertical		or		diagonal
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
				return false


		var base_score = get_cell_value(pos0)+get_cell_value(pos1)
		var distance = max(abs(i),abs(j))
		var full_score = base_score*main.cell_multiplier*distance*main.distance_multiplier
		if(Data.statistics['maxDistance']<distance):
			Data.statistics['maxDistance'] = distance

		if(n0==n1):
			full_score = full_score*main.pair_mult[str(n0)+str(n1)]
			if(n0==5):
				full_score = full_score*main.sum_10_mult
		else:
			full_score = full_score*main.sum_10_mult
			
		main.update_score(full_score)
		clear_cell_animation(pos0, pos1, 2)
		return true;
	else:
		# Possible Endline move needs different treatment.
		if(abs(dx)>1):
			# impossible because this move only works for the next row
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
			var base_score = get_cell_value(pos0)+get_cell_value(pos1)
			var full_score = base_score*main.cell_multiplier
			if(n0==n1):
				full_score = full_score*main.pair_mult[str(n0)+str(n1)]
				if(n0==5):
					full_score = full_score*main.sum_10_mult
			else:
				full_score = full_score*main.sum_10_mult
				
			main.update_score(full_score)
			clear_cell_animation_endline()
			return true;
		else:
			return false;
		






##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
