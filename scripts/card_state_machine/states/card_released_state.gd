extends CardState

var played: bool

# Called when the node enters the scene tree for the first time.
func enter():
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "RELEASED"
	played = false
	if not card_ui.targets.is_empty():
		played = true
		print("play card for targets", card_ui.targets)

func on_input(event: InputEvent):
	if played:
		return
	transition_requested.emit(self, CardState.State.IDLE)

#ALWAYS DRAGGABLE
#func on_gui_input(event: InputEvent):
	#if event.is_action_pressed("mouse_left"):
		#card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		#transition_requested.emit(self, CardState.State.CLICKED)
