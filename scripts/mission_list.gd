extends Node

var main
@onready var list = $ScrollContainer/VBoxContainer
signal missions_ready

func init_missions():
	for child in list.get_children():
		child.queue_free()

	print('creating missions')
	list.add_child(MissionFactory.create_mission(MissionFactory.CLEAR_CELLS,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.CLEAR_ROWS,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.CLEAR_TABLES,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.PLAY_GAMES,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.CLEAR_SUM_10S,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.BUY_UPGRADES,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.HIGH_SCORE,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.MAX_MONEY,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.TOTAL_MONEY,''))
	list.add_child(MissionFactory.create_mission(MissionFactory.MAX_DISTANCE,''))

	for i in range(1,10):
		list.add_child(MissionFactory.create_mission(MissionFactory.CLEAR_PAIRS,str(i*11)))

	# needed to dynamically adjust container size so all missions are showed correctly
	self.call_deferred("adjust_height")
	await get_tree().process_frame
	sort_missions()
	complete_missions_at_init()
	list.queue_sort()
	list.queue_redraw()
	emit_signal("missions_ready")


func adjust_height():
	list.custom_minimum_size.y = list.get_theme_constant("separation") * list.get_child_count()

func sort_missions():
	var mission_nodes = list.get_children()
	mission_nodes.sort_custom(func(a, b):
		return a.mission.get_progress_percentage() > b.mission.get_progress_percentage()
	)
	for node in mission_nodes:
		list.remove_child(node)
		list.add_child(node)

func check_claimable_missions():
	for node in list.get_children():
		var tween = create_tween()
		if node.mission.get_progress_percentage() < 100:
			node.claim_button.disabled = true
			tween.tween_property(
				node.get_node('CenterContainer/Panel'), 
				"modulate", Color(1,1,1), 0.25
			)
		else:
			node.claim_button.disabled = false
			tween.tween_property(
				node.get_node('CenterContainer/Panel'), 
				"modulate", Color(0.5, 1, 0.5), 0.25
			)

func render_missions():
	for node in list.get_children():
		node.render()

func update_layout():
	render_missions()
	sort_missions()
	check_claimable_missions()
	$ScrollContainer.scroll_vertical = 0



func complete_missions_at_init():
	for node in list.get_children():
		while(node.mission.complete_mission()):
			continue
		node.render()
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")
	MissionFactory.set_main_reference(main)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
