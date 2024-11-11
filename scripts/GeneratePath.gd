extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func rook_path(rook_position: int, self_board: int, enemy_board: int, is_black: bool) -> int:
	var legal_moves: int = 0
	# calculate moves to the right
	for i in range(rook_position + 1, 64):
		if i % 8 == 0:
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	# calculate moves to the left
	for i in range(rook_position - 1, -1, -1):
		if i % 8 == 7:
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	# calculate moves up
	for i in range(rook_position + 8, 64, 8):
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	# calculate moves down
	for i in range(rook_position - 8, -1, -8):
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	return legal_moves


func knight_path(knight_position: int, self_board: int, enemy_board: int, is_black: bool) -> int:
	# Initial knight move mask, all potential knight move offsets in bitboard
	var knight_mask: int = 0
	
	# Knight moves offsets on a 64-bit board (2 rows up/down, 1 column left/right or vice versa)
	var knight_offsets = [
		15, 17, 6, 10,  # Positive offsets
		-15, -17, -6, -10  # Negative offsets
	]

	# Iterate through all possible knight moves
	for offset in knight_offsets:
		var target_position = knight_position + offset
		
		# Check if the target position is still on the board (between 0 and 63)
		if target_position >= 0 and target_position < 64:
			# Prevent knight from wrapping around horizontally (columns A/H)
			if abs((knight_position % 8) - (target_position % 8)) <= 2:
				knight_mask |= (1 << target_position)  # Set the bit at the target position

	# Remove invalid moves where knight would land on a friendly piece
	knight_mask &= ~self_board

	# Mask to ensure the knight only attacks enemy pieces
	knight_mask &= (enemy_board | ~self_board)

	return knight_mask





func bishop_path(bishop_position: int, self_board: int, enemy_board: int, is_black: bool) -> int:
	var legal_moves: int = 0
	# calculate moves to the top left
	for i in range(bishop_position + 9, 64, 9):
		if i % 8 == 0:
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	# calculate moves to the top right
	for i in range(bishop_position + 7, 64, 7):
		if i % 8 == 7:
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	# calculate moves to the bottom left
	for i in range(bishop_position - 7, -1, -7):
		if i % 8 == 0:
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	# calculate moves to the bottom right
	for i in range(bishop_position - 9, -1, -9):
		if i % 8 == 7:
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i

	return legal_moves


func queen_path(queen_position: int, self_board: int, enemy_board: int, is_black: bool) -> int:
	return bishop_path(queen_position, self_board, enemy_board, is_black) | rook_path(queen_position, self_board, enemy_board, is_black)


func king_path(king_position: int, self_board: int, enemy_board: int, is_black: bool) -> int:
	var king_mask: int = 460039
	var shift_amount = king_position - 9
	if shift_amount >= 0:
		king_mask <<= shift_amount
	else:
		king_mask >>= -shift_amount

	if king_position % 8 > 6:
		king_mask &= ~0b0000000000000000000000000000000000000000000000000000000000000110
	if king_position % 8 < 1:
		king_mask &= ~0b0000000000000000000000000000000000000000000000000000000000000001
	king_mask ^= self_board & king_mask
	return king_mask


func pawn_path(pawn_position: int, self_board: int, enemy_board: int, is_black: bool) -> int:
	var pawn_mask: int = 0
	var attack_mask: int = 0

	if is_black:
		if pawn_position >= 47 and pawn_position < 56:
			pawn_mask = 0x80800000000000
		else:
			pawn_mask = 0x80000000000000

		pawn_mask >>= 63 - pawn_position
		if ((self_board | enemy_board) & (1 << (pawn_position - 8))) != 0:
			pawn_mask = 0
		attack_mask = 0xA0000000000000
		if pawn_position == 63:
			attack_mask <<= 1
		else:
			attack_mask >>= 62 - pawn_position
	else:
		if pawn_position >= 7 and pawn_position < 16:
			pawn_mask = 0x10100
		else:
			pawn_mask = 0x100

		pawn_mask <<= pawn_position
		if ((self_board | enemy_board) & (1 << (pawn_position + 8))) != 0:
			pawn_mask = 0
		attack_mask = 0x500
		if pawn_position == 0:
			attack_mask >>= 1
		else:
			attack_mask <<= pawn_position - 1

	if pawn_position % 8 > 6:
		attack_mask &= ~0b0000000000000000000000000000000000000000000000000000000000000110
	if pawn_position % 8 < 1:
		attack_mask &= ~0b0000000000000000000000000000000000000000000000000000000000000001

	attack_mask &= enemy_board
	pawn_mask ^= pawn_mask & (self_board | enemy_board)
	pawn_mask |= attack_mask
	return pawn_mask
