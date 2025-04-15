extends BaseMission
class_name MissionBuyUpgrades

func set_objective():
	objective = 10*level

func init(init_level, mission_name, mission_description, main_reference):
	super.init(init_level, mission_name, mission_description, main_reference)
	stat = "upgradesBought"
	set_objective()

func complete_mission():
	if(super.complete_mission()):
		set_objective()
		reward()
		return true
	return false
		
func reward():
	if(main.shop_discount<=0.1):
		main.shop_discount = 1
	else:
		main.shop_discount -= 0.05

