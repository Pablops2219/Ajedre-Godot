extends Control

@onready var casilla_escena = preload("res://casilla.tscn")
@onready var tablero_cuadricula = $Ajedre/CuadriculaTablero
@onready var escena_pieza = preload("res://pieza.tscn")
@onready var tablero_ajedrez = $Ajedre

var array_cuadricula := []
var array_piezas := []
var icon_offset := Vector2(39,39)
#Creo que esto guarda las posiciones iniciales de las piezas
var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
var pieza_seleccionada = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(64):
		crear_casillas()
	
	var colorbit = 0
	for i in range(8):
		for j in range(8):
			if j%2 == colorbit:
				array_cuadricula[i*8+j].set_color_fondo(Color.LIGHT_PINK)
		if colorbit==0:
			colorbit=1
		else: colorbit=0
		
	array_piezas.resize(64)
	array_piezas.fill(0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass
	
	
func crear_casillas():
	var nueva_casilla = casilla_escena.instantiate()
	nueva_casilla.id_casilla = array_cuadricula.size()
	tablero_cuadricula.add_child(nueva_casilla)
	array_cuadricula.push_back(nueva_casilla)
	nueva_casilla.casilla_seleccionada.connect(_on_casilla_seleccionada)

func _on_casilla_seleccionada(casilla):
	if not pieza_seleccionada:
		return
	mover_pieza(pieza_seleccionada, casilla.id_casilla)
	pieza_seleccionada = null

func mover_pieza(pieza, posicion):
	if array_piezas[posicion]:
		array_piezas[posicion].queue_free()
		array_piezas[posicion] = 0
	
	var tween = get_tree().create_tween()
	tween.tween_property(pieza, "global_position", array_cuadricula[posicion].global_position + icon_offset, 0.2)
	array_piezas[pieza.id_casilla] = 0 #delete piece from orgiinal spot
	array_piezas[posicion] = pieza #move it to the new location
	pieza.id_casilla = posicion

func añadir_pieza(tipo_pieza, posicion) :
	var nueva_pieza = escena_pieza.instantiate()
	tablero_ajedrez.add_child(nueva_pieza)
	nueva_pieza.tipo = tipo_pieza
	nueva_pieza.cargar_icono(tipo_pieza)
	#"global_position" es una propiedad preestablecida por Godot cojone
	nueva_pieza.global_position = array_cuadricula[posicion].global_position + icon_offset
	array_piezas[posicion] = nueva_pieza
	nueva_pieza.id_casilla = posicion
	nueva_pieza.pieza_seleccionada.connect(_on_pieza_seleccionada)

func set_filtro_tablero(bitmap:int):
	for i in range(64):
		if bitmap & 1:
			array_cuadricula[63-i].set_filtro(DataHandler.estado_casillas.Vacia)
		bitmap = bitmap >> 1

func _on_pieza_seleccionada(pieza):
	if not pieza_seleccionada:
		pieza_seleccionada = pieza
		print("pieza_seleccionada")
	else:
		_on_casilla_seleccionada(array_cuadricula[pieza.id_casilla])

func parse_fen(fen : String):
	
	var tablerostate = fen.split(" ")
	var tablero_index := 0
	for i in tablerostate[0]:
		if i == "/":continue
		if i.is_valid_int():
			tablero_index += i.to_int()
		else:
			añadir_pieza(DataHandler.fen_dict[i], tablero_index)
			tablero_index +=1

func _on_button_pressed():
	parse_fen(fen)
	#set_filtro_tablero(1023)

func _on_button_2_pressed():
	init_bitboard(fen) 
	set_filtro_tablero(get_black_bitboard())
	get_white_bitboard()
	print("?")

enum PieceNames { BISHOP, KING, KNIGHT, PAWN, QUEEN, ROOK }
var fen_dict = {
	'b': 0,
	'k': 1,
	'n': 2,
	'p': 3,
	'q': 4,
	'r': 5
}


var white_pieces = [0, 0, 0, 0, 0, 0]
var black_pieces = [0, 0, 0, 0, 0, 0]


func clear_bitboard():
	for i in range(white_pieces.size()):
		white_pieces[i] = 0
	for i in range(black_pieces.size()):
		black_pieces[i] = 0

func set_board(whites: Array, blacks: Array):
	for i in range(whites.size()):
		white_pieces[i] = whites[i]
	for i in range(blacks.size()):
		black_pieces[i] = blacks[i]

func init_bitboard(fen: String):
	clear_bitboard()
	var fen_split = fen.split(" ")
	for i in fen_split[0]:
		if i == '/':
			continue
		if i.is_valid_int():
			var shift_amount = int(i)
			left_shift(shift_amount)
			continue
		left_shift(1)
		if i >= 'A' and i <= 'Z':
			white_pieces[fen_dict[i.to_lower()]] |= 1
		else:
			black_pieces[fen_dict[i]] |= 1
	print("Bitboard init successfully")

func get_black_bitboard() -> int:
	var ans = 0
	for i in black_pieces:
		ans |= i
	return ans

func get_white_bitboard() -> int:
	var ans = 0
	for i in white_pieces:
		ans |= i
		print(ans)
	return ans

func left_shift(shift_amount: int):
	for piece in range(black_pieces.size()):
		black_pieces[piece] <<= shift_amount
	for piece in range(white_pieces.size()):
		white_pieces[piece] <<= shift_amount
