extends BaseMission
class_name MissionMaxDistance

func set_objective():
	objective = level

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "maxDistance"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()
		return true
	return false
		
func reward():
	if(level<5):
		main.distance_multiplier += 0.25
	elif(level<10):
		main.distance_multiplier += 1
	else:
		main.distance_multiplier += 5

	

