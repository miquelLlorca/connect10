extends BaseMission
class_name MissionMaxMoney

func set_objective():
	objective = 100*level

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "sum10s"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()
		return true
	return false
		
func reward():
	main.mission_money_multiplier += 1

