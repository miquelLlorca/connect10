extends Node

const CLEAR_CELLS = 'CLEAR_CELLS'
const CLEAR_ROWS = 'CLEAR_ROWS'
const CLEAR_TABLES = 'CLEAR_TABLES'
const CLEAR_SUM_10S = 'CLEAR_SUM_10S'
const PLAY_GAMES = 'PLAY_GAMES'
const BUY_UPGRADES = 'BUY_UPGRADES'
const HIGH_SCORE = 'HIGH_SCORE'
const MAX_MONEY = 'MAX_MONEY'
const TOTAL_MONEY = 'TOTAL_MONEY'
const MAX_DISTANCE = 'MAX_DISTANCE'
const CLEAR_PAIRS = 'CLEAR_PAIRS'

var main

func create_mission(mission_type, subtype):
	var aux_mission
	if(mission_type==CLEAR_CELLS):
		aux_mission = load("res://scripts/missions/mission_clear_cells.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Cell destroyer', 
			'Clear cells to increase cell score multiplier.', main)

	elif(mission_type==CLEAR_ROWS):
		aux_mission = load("res://scripts/missions/mission_clear_rows.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Row remover', 
			'Clear rows to increase row score multiplier.', main)

	elif(mission_type==CLEAR_TABLES):
		aux_mission = load("res://scripts/missions/mission_clear_tables.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Table cleaner', 
			'Clear complete tables to increase table score multiplier.', main)

	elif(mission_type==PLAY_GAMES):
		aux_mission = load("res://scripts/missions/mission_play_games.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Am I addicted?', 
			'Play games to make them more profitable.', main)

	elif(mission_type==CLEAR_SUM_10S):
		aux_mission = load("res://scripts/missions/mission_sum_10s.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'GAME NAME :O', 
			'Clear cells that sum 10 to increase their multiplier.', main)

	elif(mission_type==BUY_UPGRADES):
		aux_mission = load("res://scripts/missions/mission_buy_upgrades.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Compulsive buyer', 
			'Buy upgrades to make them cheaper.', main)

	elif(mission_type==HIGH_SCORE):
		aux_mission = load("res://scripts/missions/mission_high_score.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Pro gamer', 
			'Get better high scores to improve money earned each run.', main)

	elif(mission_type==MAX_MONEY):
		aux_mission = load("res://scripts/missions/mission_max_money.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Investor mindset', 
			'Earn bigger rewards by run to get even more money.', main)

	elif(mission_type==TOTAL_MONEY):
		aux_mission = load("res://scripts/missions/mission_total_money.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Money hoarder', 
			'Earning money makes you earn even more money.', main)

	elif(mission_type==MAX_DISTANCE):
		aux_mission = load("res://scripts/missions/mission_max_distance.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Hawkeye!', 
			'Clear cells further apart to upgrade the distance multiplier.', main)

	elif(mission_type==CLEAR_PAIRS):
		aux_mission = load("res://scripts/missions/mission_clear_pairs.gd")
		aux_mission = aux_mission.new()
		aux_mission.init(1, 'Every pot has its lid ('+subtype+')', 
			'Clear pairs of '+subtype[0]+'s to increase their multiplier.', main)
		aux_mission.set_pair(subtype)
		aux_mission.set_objective()
	
	var aux_mission_scene = load("res://scenes/mission.tscn").instantiate()
	aux_mission_scene.init(aux_mission)
	aux_mission_scene.call_deferred("init_complete")
	aux_mission_scene.call_deferred("render")
	return aux_mission_scene

func set_main_reference(ref):
	main = ref
