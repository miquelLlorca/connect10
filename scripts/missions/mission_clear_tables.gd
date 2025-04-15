extends BaseMission
class_name MissionClearTables

func set_objective():
	objective = 10*level

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "tablesCleared"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()
		return true
	return false

func reward():
	main.table_multiplier += 0.25
