extends Mission
class_name MissionClearCells

func set_objective():
	objective = 10*level
	print('CHILd')

func init(init_level, stat_to_check, main_reference):
	super.init(init_level, stat_to_check, main_reference)
	set_objective()
	print("inits")
	print(level, stat, objective)

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		print('OKI')
		print(level, objective)

# func reward():
