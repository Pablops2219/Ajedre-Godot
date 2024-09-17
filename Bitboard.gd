extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		if i.is_digit():
			var shift_amount = int(i)
			left_shift(shift_amount)
			continue
		left_shift(1)
		if i.is_upper():
			white_pieces[DataHandler.fen_dict[i.to_lower()]] |= 1
		else:
			black_pieces[DataHandler.fen_dict[i]] |= 1
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
	return ans

func left_shift(shift_amount: int):
	for piece in range(black_pieces.size()):
		black_pieces[piece] <<= shift_amount
	for piece in range(white_pieces.size()):
		white_pieces[piece] <<= shift_amount


#
	#public ulong GetWhiteBitboard(){
		#ulong ans = 0;
		#foreach(ulong i in whitePieces){
			#ans |= i;
		#}
		#return ans;
	#}
#
#
	#public void ClearBitboard(){
		#Array.Clear(whitePieces);
		#Array.Clear(blackPieces);
	#}
#
	#public void SetBoard(ulong[] Whites, ulong[] Blacks){
		#Array.Copy(Whites, whitePieces, Whites.Length);
		#Array.Copy(Blacks, blackPieces, Blacks.Length);
	#}
#
	#public void InitBitBoard(string fen){
		#ClearBitboard();
		#string[] fen_split = fen.Split(" ");
		#foreach (char i in fen_split[0]){
			#if (i.Equals('/'))
				#continue;
			#if (Char.IsDigit(i)){
				#int shiftAmount = int.Parse(i.ToString());
				#LeftShift(shiftAmount);
				#continue;
			#}
			#LeftShift(1);
			#if(Char.IsUpper(i)){
				#whitePieces[DataHandlerCS.FenDict[Char.ToLower(i)]] |= 1UL;
			#}else{
				#blackPieces[DataHandlerCS.FenDict[i]] |= 1UL;
			#}
		#}
		#GD.Print("Bitboard init successfully");
	#}
