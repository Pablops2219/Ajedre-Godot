extends Node

var is_playing: bool = false
@export var is_playing_debug: bool = false
var white_moves: bool = true  # Variable privada o protegida
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var label = $RichTextLabel
@onready var gui: Control = self.get_parent()



func can_move(piece):
	var is_piece_white:bool =gui.is_piece_white(piece)
	if is_playing_debug:
		return true
	if is_piece_white && white_moves:
		return true
	elif !is_piece_white && !white_moves:
		return true
	else: 
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

# Getter para white_moves
func white_moves_next() -> bool:
	return white_moves

func next_turn():
	if white_moves: 
		white_moves = false
		shake_and_display_text("black")
	else:
		white_moves =true
		shake_and_display_text("white")
	pass

func _on_init_button_pressed():
	is_playing = true

func shake_and_display_text(color: String):
	animated_sprite_2d.play(color)
	var message: String = ""
	if color == "white":
		message = "𝓦𝓱𝓲𝓽𝓮 𝓶𝓸𝓿𝓮𝓼"
	if color == "black":
		message = "𝓑𝓵𝓪𝓬𝓴 𝓶𝓸𝓿𝓮𝓼 "
	var message_with_effects: String = "[center][shake rate=50.0 level=30 connected=1]" + message + "[/shake][/center]"
	if !white_moves:
		message_with_effects = message_with_effects.insert(8,"[color=#000000]")
		message_with_effects = message_with_effects.insert(message_with_effects.length()-9,"[/color]")
		message = message.insert(0,"[color=#000000]")
		message = message.insert(message.length(),"[/color]")
	label.set_text(message_with_effects)
	await get_tree().create_timer(0.2).timeout
	label.set_text("[center]" + message + "[center]")
		
	pass


func _on_debug_pressed():
	if is_playing_debug:
		is_playing_debug = false
	else:
		is_playing_debug = true
