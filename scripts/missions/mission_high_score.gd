extends BaseMission
class_name MissionHighScore

func set_objective():
	objective = 10000*level

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "highScore"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()
		return true
	return false
		
func reward():
	if(main.score_to_money<=100):
		main.score_to_money = 1
	else:
		main.score_to_money -= 100

