extends ColorRect

@onready var filter_path = $Filter
var slot_ID := -1
signal slot_clicked(slot)
var state = DataHandler.slot_states.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_background(c)-> void:
	color = c

func set_filter(color = DataHandler.slot_states.NONE):
	state=color
	match color:
		DataHandler.slot_states.NONE:
			filter_path.color = Color(0,0,0,0)
		DataHandler.slot_states.FREE:
			filter_path.color = Color(0,1,0,0.4)
		DataHandler.slot_states.CHECK:
			filter_path.color = Color(0,0,0.6,0.9)
	pass


func _on_filter_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("slot_clicked", self)
