extends BaseMission
class_name MissionClearCells

func set_objective():
	objective = 1000*level

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "cellsCleared"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()

func reward():
	main.cell_multiplier += 0.25
