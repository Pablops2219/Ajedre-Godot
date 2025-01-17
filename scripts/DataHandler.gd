extends Node

var assets := []
enum PieceNames {WHITE_BISHOP, WHITE_KING, WHITE_KNIGHT, WHITE_PAWN, WHITE_QUEEN, WHITE_ROOK, BLACK_BISHOP, BLACK_KING, BLACK_KNIGHT, BLACK_PAWN, BLACK_QUEEN, BLACK_ROOK}
var fen_dict := {	"b" = PieceNames.BLACK_BISHOP, "k" = PieceNames.BLACK_KING, 
					"n" = PieceNames.BLACK_KNIGHT, "p" = PieceNames.BLACK_PAWN, 
					"q" = PieceNames.BLACK_QUEEN, "r" = PieceNames.BLACK_ROOK, 
					"B" = PieceNames.WHITE_BISHOP, "K" = PieceNames.WHITE_KING, 
					"N" = PieceNames.WHITE_KNIGHT, "P" = PieceNames.WHITE_PAWN, 
					"Q" = PieceNames.WHITE_QUEEN, "R" = PieceNames.WHITE_ROOK, }

enum slot_states {NONE, FREE, CHECK}

# Called when the node enters the scene tree for the first time.
func _ready():
	assets.append("res://art_assets/pieces/white_bishop.png")
	assets.append("res://art_assets/pieces/white_king.png")
	assets.append("res://art_assets/pieces/white_knight.png")
	assets.append("res://art_assets/pieces/white_pawn.png")
	assets.append("res://art_assets/pieces/white_queen.png")
	assets.append("res://art_assets/pieces/white_rook.png")
	assets.append("res://art_assets/pieces/black_bishop.png")
	assets.append("res://art_assets/pieces/black_king.png")
	assets.append("res://art_assets/pieces/black_knight.png")
	assets.append("res://art_assets/pieces/black_pawn.png")
	assets.append("res://art_assets/pieces/black_queen.png")
	assets.append("res://art_assets/pieces/black_rook.png")
