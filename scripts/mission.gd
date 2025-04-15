extends Control

var main
var mission

@onready var title = $CenterContainer/Panel/VBoxContainer/Title
@onready var description = $CenterContainer/Panel/VBoxContainer/Description
@onready var progress = $CenterContainer/Panel/VBoxContainer/Progress
@onready var claim_button = $CenterContainer/Panel/VBoxContainer/Claim

func init(mission_obj):
	mission = mission_obj
	print(mission.name)
	print(title)

func render():
	title.text = mission.name
	description.text = mission.description
	progress.text = str(main.statistics[mission.stat]) + " / " + str(mission.objective)

func init_complete():
	# used when first loading game,
	# completes mission until it cant complete anymore
	pass
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
