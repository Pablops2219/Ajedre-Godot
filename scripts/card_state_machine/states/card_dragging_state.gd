extends CardState

const  DRAG_MINIMUN_THRESHOLD = 0.05
var minimun_drag_time_elapsed := false


func enter():
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.color.color = Color.NAVY_BLUE
	card_ui.state.text = "DRAGGING"
	
	minimun_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUN_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimun_drag_time_elapsed = true)

func on_input(event: InputEvent):
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("mouse_right")
	var confirm = event.is_action_pressed("mouse_left") or event.is_action_released("mouse_left")
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.IDLE)
	elif confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
	
