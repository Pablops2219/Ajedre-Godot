extends Node2D

signal piece_selected(piece)
@onready var icon_path = $Icon
var slot_ID := -1
var type : int
var slots_dict = {
	0: 'a',
	1: 'b',
	2: 'c',
	3: 'd',
	4: 'e',
	5: 'f',
	6: 'g',
	7: 'h'
}

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

func get_piece_node():
	return self

func print_relevant_info():
	var message:String = str(get_piece_node())
	message += ", " + str(piece_dict[self.type])
	message += ", " + str(index_to_coordinates(self.slot_ID))
	return message

func index_to_coordinates(index: int):
	var x = index % 8  # Columna
	var y = index / 8  # Fila
	y = 7 - y
	var result = slots_dict[x] + str(y+1)
	return result


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func load_icon(piece_name) -> void:
	icon_path.texture = load(DataHandler.assets[piece_name])

func piece_type_and_slot():
	print(piece_dict[type] , self.slot_ID)
	
	

func get_piece_type(piece):
	if(piece.type >= 6):
		return piece.type%6
	return piece.type

func _on_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", self)
