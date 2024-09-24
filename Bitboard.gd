extends Node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

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
