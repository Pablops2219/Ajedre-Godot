extends Node

var is_playing: bool = false
var white_moves: bool = true  # Variable privada o protegida
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var label = $RichTextLabel





# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

# Getter para white_moves
func get_white_moves() -> bool:
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
	label.add_theme_color_override("font_color", Color(1, 1, 1))
	label.set_text("[center][shake rate=50.0 level=30 connected=1]" + color.capitalize() + "moves[/shake]")
	await get_tree().create_timer(0.2).timeout
	label.set_text("[center]" + color.capitalize() + " moves")
		
	pass
