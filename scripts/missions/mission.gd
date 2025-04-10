# mission.gd
extends Resource
class_name Mission

var name: String
var level: int
var stat: String # the stat to look for
var objective: int # will be determined by level
var main

func init(init_level, main_reference):
	level = init_level
	main = main_reference

func get_progress_percentage():
	return 100 * main.statistics[stat] / objective

func complete_mission():
	# this is implemented in parent class
	if(get_progress_percentage()>=100):
		level += 1
		return true
	return false
