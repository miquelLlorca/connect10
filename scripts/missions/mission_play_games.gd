extends Mission
class_name MissionPlayGames

func set_objective():
	objective = 10*level

func init(init_level, main_reference):
	super.init(init_level, main_reference)
	stat = "gamesPlayed"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()

func reward():
	if(main.score_to_money<=10):
		main.score_to_money = 1
	else:
		main.score_to_money -= 10

