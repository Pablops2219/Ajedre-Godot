extends Node

var assets := []
enum NombresPiezas {WHITE_BISHOP, WHITE_KING, WHITE_KNIGHT, WHITE_PAWN, WHITE_QUEEN, WHITE_ROOK, BLACK_BISHOP, BLACK_KING, BLACK_KNIGHT, BLACK_PAWN, BLACK_QUEEN, BLACK_ROOK}
var fen_dict := {	"b" = NombresPiezas.BLACK_BISHOP, "k" = NombresPiezas.BLACK_KING, 
					"n" = NombresPiezas.BLACK_KNIGHT, "p" = NombresPiezas.BLACK_PAWN, 
					"q" = NombresPiezas.BLACK_QUEEN, "r" = NombresPiezas.BLACK_ROOK, 
					"B" = NombresPiezas.WHITE_BISHOP, "K" = NombresPiezas.WHITE_KING, 
					"N" = NombresPiezas.WHITE_KNIGHT, "P" = NombresPiezas.WHITE_PAWN, 
					"Q" = NombresPiezas.WHITE_QUEEN, "R" = NombresPiezas.WHITE_ROOK, }

enum estado_casillas {Vacia, Ninguno}

# Called when the node enters the scene tree for the first time.
func _ready():
	assets.append("res://art_assets/white_bishop.png")
	assets.append("res://art_assets/white_king.png")
	assets.append("res://art_assets/white_knight.png")
	assets.append("res://art_assets/white_pawn.png")
	assets.append("res://art_assets/white_queen.png")
	assets.append("res://art_assets/white_rook.png")
	assets.append("res://art_assets/black_bishop.png")
	assets.append("res://art_assets/black_king.png")
	assets.append("res://art_assets/black_knight.png")
	assets.append("res://art_assets/black_pawn.png")
	assets.append("res://art_assets/black_queen.png")
	assets.append("res://art_assets/black_rook.png")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
