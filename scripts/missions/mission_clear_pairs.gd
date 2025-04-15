extends BaseMission
class_name MissionPairs

var pair 

func set_objective():
	objective = level*pair.to_int()

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "pairs"

func set_pair(pair_stat):
	pair = pair_stat

func get_progress_percentage():
	return 100 * main.statistics[stat][pair] / objective


func complete_mission():
	# this is implemented in parent class
	if(get_progress_percentage()>=100):
		level += 1
		set_objective()
		reward()
		return true
	return false
		
func reward():
	main.pair_mult[pair] += float("0."+pair)

func get_progress_string():
	return str(main.statistics[stat][pair]) + " / " + str(objective)
