extends Node2D
@onready var sprite_2d = $Sprite2D

signal hovered
signal hovered_off
var card_type = 0


var card_dictionary = {
	0: "time_stop",
	1: "xd"
	
}


# Called when the node enters the scene tree for the first time.
func _ready():
	#All cards must be a child of CardManager or this will throw an error
	get_parent().connect_card_signals(self)
	
func get_card_type():
	return card_type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)
