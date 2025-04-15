extends BaseMission
class_name MissionClearRows

func set_objective():
	objective = 100*level

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "rowsCleared"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()

func reward():
	main.row_multiplier += 0.25
