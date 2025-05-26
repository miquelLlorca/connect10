extends Panel

var suit 
var suit_textures
var cell_value = 0

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

func set_value(value):
	cell_value = value
	if(value!=0):
		var n = randi_range(0, 3)
		suit = SUITS[n]
	queue_redraw()

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
