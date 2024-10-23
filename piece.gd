extends Node2D

signal piece_selected(piece)
@onready var icon_path = $Icon
var slot_ID := -1
var type : int

var piece_dict = {
	0: 'white bishop',
	1: 'white king',
	2: 'white knight',
	3: 'white pawn',
	4: 'white queen',
	5: 'white rook',
	6: 'black bishop',
	7: 'black king',
	8: 'black knight',
	9: 'black pawn',
	10: 'black queen',
	11: 'black rook'
}




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func load_icon(piece_name) -> void:
	icon_path.texture = load(DataHandler.assets[piece_name])

func _to_string():
	print(piece_dict[type])

func get_piece_type(piece):
	if(piece.type >= 6):
		return piece.type%6
	return piece.type

func _on_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", self)
