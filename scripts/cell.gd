extends Panel

var parentPos
var original_colour
var cell_value = 0
@onready var shadow = $Shadow
@onready var card = $Card

var cell_width = self.size.x
var cell_height = self.size.y



const SELECTION_OFFSET = 15



func select_cell():
	shadow.visible = true
	var tween = create_tween()
	tween.tween_property(self, "position:y", self.position.y - SELECTION_OFFSET, 0.1)

func deselect_cell():
	shadow.visible = false
	var tween = create_tween()
	tween.tween_property(self, "position:y", self.position.y + SELECTION_OFFSET, 0.1)




func flip_animation(value):
	var duration = 0.08
	var tween1 = create_tween()
	tween1.tween_property(self, "scale:x", 0.1, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	var tween2 = create_tween()
	tween2.tween_property(self, "position:x", self.position.x + 25, duration).set_ease(Tween.EASE_IN)
	await tween1.finished
	await tween2.finished

	cell_value = value
	card.set_value(value)
	queue_redraw()

	var tween3 = create_tween()
	tween3.tween_property(self, "position:x", self.position.x - 25, duration).set_ease(Tween.EASE_IN)
	var tween4 = create_tween()
	tween4.tween_property(self, "scale:x", 1.0, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween3.finished
	await tween4.finished

	
func set_value(value, animation):
	if(value!=0):
		cell_value = value
		card.set_value(value)
		call_deferred('queue_redraw')
	elif(value==0 and animation):
			flip_animation(value)
			


	
func set_colour():
	self.modulate = Color(0.1, 0.5, 0.9)

func clean_colour():
	self.modulate = original_colour
	
func _on_cell_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var column = int((position.x-parentPos.x) / cell_width)
		var row = int((position.y-parentPos.y) / cell_height)
		#print("Cell clicked at: ", self.position, " -> ", row, ",", column) 
		get_parent()._on_cell_click(row, column)
		
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	# gets the pos of the center container as when the table is resetted the position gets messed up
	parentPos = get_parent().get_parent().position
	original_colour = self.modulate
	self.connect("gui_input", _on_cell_input)
	self.z_as_relative = true
	shadow.z_index = 0
	card.z_index = 1
	shadow.position.y += SELECTION_OFFSET

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
