extends State

@export
var white_turn: State
@export
var black_turn: State

var match_started := bool ns

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed('move_left') or Input.is_action_just_pressed('move_right'):
		return move_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null

func _on_initbutton_pressed():
	match_started = true
