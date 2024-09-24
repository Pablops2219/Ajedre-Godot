extends Control

@onready var slot_scene = preload("res://slot.tscn")
@onready var board_grid = $Ajedre/CuadriculaTablero
@onready var piece_scene = preload("res://piece.tscn")
@onready var chess_board = $Ajedre
@onready var bitboard = $Bitboard


var grid_array := []
var piece_array := []
var icon_offset := Vector2(39,39)
#Creo que esto guarda las posiciones iniciales de las piezas
var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
var piece_selected = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(64):
		create_slot()
		
	var colorbit =0
	for i in range(8):
		for j in range(8):
			if j%2 == colorbit:
				grid_array[i*8+j].set_background(Color.CORNFLOWER_BLUE)
		if colorbit==0:
			colorbit=1
		else: colorbit=0
		
	piece_array.resize(64)
	piece_array.fill(0)
	pass 

func _process(delta: float) -> void:
	pass

func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	board_grid.add_child(new_slot)
	grid_array.push_back(new_slot)
	new_slot.slot_clicked.connect(_on_slot_clicked)

func _on_slot_clicked(slot)->void:
	if not piece_selected:
		return
	move_piece(piece_selected, slot.slot_ID)
	clear_board_filter()
	piece_selected = null

func move_piece(piece, location):
	if piece_array[location]:
		piece_array[location].queue_free()
		piece_array[location] = 0 
	
	var tween = get_tree().create_tween()
	tween.tween_property(piece, "global_position", grid_array[location].global_position +icon_offset, 0.2)
	piece_array[piece.slot_ID] = 0 #delete piece from orgiinal spot
	piece_array[location] = piece #move it to the new location
	piece.slot_ID = location

func add_piece(piece_type, location)->void:
	var new_piece = piece_scene.instantiate()
	chess_board.add_child(new_piece)
	new_piece.type = piece_type
	new_piece.load_icon(piece_type)
	new_piece.global_position = grid_array[location].global_position + icon_offset
	piece_array[location] = new_piece
	new_piece.slot_ID = location
	new_piece.piece_selected.connect(_on_piece_selected)

func set_board_filter(bitmap:int):
	for i in range(64):
		if bitmap & 1:
			grid_array[63-i].set_filter(DataHandler.slot_states.FREE)
		bitmap = bitmap >> 1

func clear_board_filter():
	for i in grid_array:
		i.set_filter()

func _on_piece_selected(piece):
	if not piece_selected:
		piece_selected = piece
		print("piece_selected")
	else:
		pass


func parse_fen(fen : String)->void:
	var boardstate = fen.split(" ")
	var board_index := 0
	for i in boardstate[0]:
		if i == "/":continue
		if i.is_valid_int():
			board_index += i.to_int()
		else:
			add_piece(DataHandler.fen_dict[i], board_index)
			board_index +=1

func _on_button_pressed():
	parse_fen(fen)

func _on_button_2_pressed():
	bitboard.init_bitboard(fen) 

func _on_button_3_pressed():
	set_board_filter(bitboard.get_black_bitboard())
