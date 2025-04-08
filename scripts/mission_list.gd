extends Node

var main

var cell_mission
var rows_mission

func init_missions():
	var aux_mission = load("res://scripts/missions/mission_clear_cells.gd")
	cell_mission = aux_mission.new()
	cell_mission.init(1, 'cellsCleared', self)

	aux_mission = load("res://scripts/missions/mission_clear_rows.gd")
	rows_mission = aux_mission.new()
	rows_mission.init(1, 'rowsCleared', self)

	#and more

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
