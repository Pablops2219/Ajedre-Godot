extends Control

@onready var slot_scene = preload("res://slot.tscn")
@onready var board_grid = $Ajedre/CuadriculaTablero
@onready var piece_scene = preload("res://piece.tscn")
@onready var chess_board = $Ajedre
@onready var bitboard = $Bitboard
@onready var generate_path = $GeneratePath
@onready var match_handler = $MatchHandler


var grid_array := []
var piece_array := []
var icon_offset := Vector2(39,39)
#Creo que esto guarda las posiciones iniciales de las piezas
var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
var piece_selected = null
var gamestart := false

func _process(delta):
	if Input.is_action_just_pressed("mouse_right") and piece_selected:
		piece_selected = null
		clear_board_filter()

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
	
	await get_tree().process_frame
	init_match()


func _on_slot_clicked(slot)->void:
	if slot.state != DataHandler.slot_states.FREE:
		clear_board_filter()
		piece_selected = null
		return
	if(!match_handler.can_move(is_piece_white(piece_selected))):
		return
	move_piece(piece_selected, slot.slot_ID)
	match_handler.next_turn()
	clear_board_filter()
	piece_selected = null

func is_piece_white(piece):
	if piece.type<6: return true
	else: return false

func get_piece_type(piece):
	if(piece.type >= 6):
		return piece.type%6
	return piece.type

func _on_piece_selected(piece):
	piece._to_string()
	if !match_handler.is_playing:
		return
	if piece_selected:
		_on_slot_clicked(grid_array[piece.slot_ID])
	else:
		piece_selected = piece
		var WhiteBoard = bitboard.get_white_bitboard()
		var BlackBoard = bitboard.get_black_bitboard()
		#check for color
		var isBlack := true
		var function_to_call : String
		if is_piece_white(piece): isBlack = false 
		#match piece type
		match piece.type%6:
			0:
				function_to_call = "bishop_path"
			1:
				function_to_call = "king_path"
			2:
				function_to_call = "knight_path"
			3:
				function_to_call = "pawn_path"
			4:
				function_to_call = "queen_path"
			5:
				function_to_call = "rook_path"
		if isBlack:
			set_board_filter(generate_path.call(function_to_call,63 - piece.slot_ID, BlackBoard, WhiteBoard, isBlack))
		else:
			set_board_filter(generate_path.call(function_to_call,63 - piece.slot_ID, WhiteBoard, BlackBoard, isBlack))

func update_board(from_location, to_location):
	if piece_array[to_location]:
		if piece_array[to_location].type%6 == 1: #if the captured piece is king, end
			gamestart = false
		piece_array[to_location].queue_free()
		piece_array[to_location] = 0
	var tween = get_tree().create_tween()	
	tween.tween_property(piece_array[from_location], "global_position",grid_array[to_location].global_position + icon_offset, 0.1)
	piece_array[to_location] = piece_array[from_location] # move it to the new location
	piece_array[from_location] = 0 # delete piece from original spot
	piece_array[to_location].slot_ID = to_location # change the piece location


func move_piece(piece, location):
	if piece_array[location]:
		remove_from_bitboard(piece_array[location])
		piece_array[location].queue_free()
		piece_array[location] = 0 
	
	remove_from_bitboard(piece)
	var tween = get_tree().create_tween()
	tween.tween_property(piece, "global_position", grid_array[location].global_position +icon_offset, 0.2)
	piece_array[piece.slot_ID] = 0 #delete piece from orgiinal spot
	piece_array[location] = piece #move it to the new location
	piece.slot_ID = location
	bitboard.add_piece(63-  location, piece.type)

func remove_from_bitboard(piece):
	bitboard.remove_piece(63-piece.slot_ID, piece.type)

#
#Resaltar las casillas a las que se puede mover una pieza
#

func set_board_filter(bitmap:int):
	for i in range(64):
		if bitmap & 1:
			grid_array[63-i].set_filter(DataHandler.slot_states.FREE)
		bitmap = bitmap >> 1

func clear_board_filter():
	for i in grid_array:
		i.set_filter()

#
#Creacion del tablero y inicializacion del juego
#

func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	board_grid.add_child(new_slot)
	grid_array.push_back(new_slot)
	new_slot.slot_clicked.connect(_on_slot_clicked)

func add_piece(piece_type, location)->void:
	var new_piece = piece_scene.instantiate()
	chess_board.add_child(new_piece)
	new_piece.type = piece_type
	new_piece.load_icon(piece_type)
	new_piece.global_position = grid_array[location].global_position + icon_offset
	piece_array[location] = new_piece
	new_piece.slot_ID = location
	new_piece.piece_selected.connect(_on_piece_selected)

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

func init_match():
	if(match_handler.is_playing):
		print("Match already in progress!!!")
		return
	parse_fen(fen)
	bitboard.init_bitboard(fen)
	match_handler.is_playing = true 

func _on_initbutton_pressed():
	init_match()


func _on_testbutton_pressed():
	set_board_filter(bitboard.get_black_bitboard())
