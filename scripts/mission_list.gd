extends Node

var main
@onready var list = $ScrollContainer/VBoxContainer

func init_missions():
	for child in list.get_children():
		child.queue_free()
	
	# Clearing cells
	var aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	var aux_mission = load("res://scripts/missions/mission_clear_cells.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Cell destroyer', 
		'Clear cells to increase cell score multiplier.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Clearing rows
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_clear_rows.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Row remover', 
		'Clear rows to increase row score multiplier.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Clearing tables
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_clear_tables.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Table cleaner', 
		'Clear complete tables to increase table score multiplier.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Play games
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_play_games.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Am I addicted?', 
		'Play games to make them more profitable.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Sum 10s
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_sum_10s.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'GAME NAME :O', 
		'Clear cells that sum 10 to increase their multiplier.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Buy upgrades
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_buy_upgrades.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Compulsive buyer', 
		'Buy upgrades to make them cheaper.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# High score
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_high_score.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Absolute gamer', 
		'Get better high scores to improve money earned each run.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Max money
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_max_money.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Investor mindset', 
		'Earn bigger rewards by run to get even more money.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Total money
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_total_money.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'Money hoarder', 
		'Earning money makes you earn even more money.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")



	# Clear pairs
	for i in range(1,10):
		aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
		aux_mission = load("res://scripts/missions/mission_clear_pairs.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Every pot has its lid ('+str(i*11)+')', 
			'Clear pairs of '+str(i)+'s to increase their multiplier.', main)
		aux_mission.set_pair(str(i*11))
		aux_mission.set_objective()
		aux_mission_scene.init(aux_mission)
		list.add_child(aux_mission_scene)
		aux_mission_scene.call_deferred("init_complete")
		aux_mission_scene.call_deferred("render")









	# Sum 10s

	# Sum 10s
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_sum_10s.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'GAME NAME :O', 
		'Clear cells that sum 10 to increase their multiplier.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Sum 10s
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_sum_10s.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'GAME NAME :O', 
		'Clear cells that sum 10 to increase their multiplier.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

	# Sum 10s
	aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission = load("res://scripts/missions/mission_sum_10s.gd")
	aux_mission = aux_mission.new()
	aux_mission.init(1, 'GAME NAME :O', 
		'Clear cells that sum 10 to increase their multiplier.', main)
	aux_mission_scene.init(aux_mission)
	list.add_child(aux_mission_scene)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")

































##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

func complete_missions():
	pass
func render_missions():
	for i in range(list.get_child_count()):
		list.get_child(i).render()

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")
	# if OS.has_feature("mobile"):
	# 	$ScrollContainer.scroll_vertical_visibility = $ScrollContainer.SCROLLBAR_NEVER



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
