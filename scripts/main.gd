extends Control

@onready var table = $Table

# Called when the node enters the scene tree for the first time.
func _ready():
	table.populate_table(3,10) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
