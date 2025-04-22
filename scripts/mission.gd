extends Control

var main
var mission

@onready var title = $CenterContainer/Panel/VBoxContainer/Title
@onready var description = $CenterContainer/Panel/VBoxContainer/Description
@onready var progress = $CenterContainer/Panel/VBoxContainer/Progress
@onready var claim_button = $CenterContainer/Panel/VBoxContainer/Claim

func init(mission_obj):
	mission = mission_obj

func complete_mission():
	print('CLAIMING')
	if(mission.complete_mission()):
		render()
		print(mission.level)
		print(mission.objective)
		if mission.get_progress_percentage() < 100:
			claim_button.disabled = true
			# $CenterContainer/Panel.modulate = Color(1,1,1)
			var tween = create_tween()
			tween.tween_property(
				$CenterContainer/Panel, 
				"modulate", Color(1,1,1), 0.25
			)


func render():
	title.text = mission.name
	description.text = mission.description
	progress.text = mission.get_progress_string()


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
	claim_button.connect("pressed", Callable(self, "complete_mission"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
