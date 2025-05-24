extends Panel

var parentPos
var original_colour
var cell_value = 0
@onready var label = $Label

var cell_width = self.size.x
var cell_height = self.size.y

var suit 
var suit_textures
const SPADES = "♠"
const HEARTS = "♥"
const DIAMONDS = "♦"
const CLUBS = "♣"
const SUITS = [SPADES, HEARTS, DIAMONDS, CLUBS]

@export var back_texture: Texture2D
@export var base_texture: Texture2D
@export var icon_texture: Texture2D
@export var font: Font
@export var label_text: String = "Card"


func _draw():
	if(cell_value==0):
		if(back_texture):
			draw_texture(back_texture, Vector2.ZERO)
	else:
		if(base_texture):
			draw_texture(base_texture, Vector2.ZERO)
		if(suit_textures and suit_textures[suit]):
			draw_texture(suit_textures[suit], Vector2(43, 2))
			# draw_texture(suit_textures[suit], Vector2(2, 42))
		if(font):
			# draw_string(font, Vector2(17,48), str(cell_value), HORIZONTAL_ALIGNMENT_LEFT, 60, 50, Color.RED)
			if(suit==CLUBS or suit==SPADES):
				draw_string(font, Vector2(17,48), str(cell_value), HORIZONTAL_ALIGNMENT_LEFT, 60, 50, Color.RED)
				draw_string(font, Vector2(15,46), str(cell_value), HORIZONTAL_ALIGNMENT_LEFT, 60, 50, Color.BLACK)
			elif(suit==HEARTS or suit==DIAMONDS):
				draw_string(font, Vector2(17,48), str(cell_value), HORIZONTAL_ALIGNMENT_LEFT, 60, 50, Color.BLACK)
				draw_string(font, Vector2(15,46), str(cell_value), HORIZONTAL_ALIGNMENT_LEFT, 60, 50, Color.RED)



		
func set_value(value):
	cell_value = value
	if(cell_value!=0):
		var n = randi_range(0, 3)
		suit = SUITS[n]
		call_deferred('queue_redraw')
	else:
		cell_value = 1
		var tween = create_tween()
		tween.tween_property(self, "scale:x", 0.1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_delay(0.1)
		cell_value = value
		tween.tween_callback(Callable(self, "queue_redraw")).set_delay(0.1)
		tween.tween_property(self, "scale:x", 1.0, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_delay(0.2)


	
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
	base_texture = load("res://assets/decks/default/front_template.png")
	back_texture = load("res://assets/decks/default/back.png")
	font = ThemeDB.fallback_font;
	# font.size = 20
	suit_textures = {
		HEARTS: load("res://assets/decks/default/corazones.png"),
		SPADES: load("res://assets/decks/default/picas.png"),
		CLUBS: load("res://assets/decks/default/treboles.png"),
		DIAMONDS: load("res://assets/decks/default/diamantes.png"),
	}




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
