extends Node2D
const CIRCULO = preload("res://circulo.png")
const TIME_STOP = preload("res://scenes/time_stop.tscn")
var COLLISION_MASK_CARD = 1
var initial_card_pos_y
var card_dictionary = {
	0: "time_stop",
	1: "xd"
	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#EVENTOS AL CLICAR UNA CARTA
		#if event.is
		if event.is_pressed():
			if raycast_check_for_card() != null :
				var carta = raycast_check_for_card()
				print(str(carta) + " Tipo: " + card_dictionary[carta.get_card_type()])
				var instance = TIME_STOP.instantiate()
				add_child(instance)
				#await get_parent().get_tree().create_timer(1.0).timeout
				#get_parent().get_tree().paused = true
			
		else:
			#print("Left click released")
			pass

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	initial_card_pos_y = card.get_child(0).position.y


func on_hovered_over_card(card):
	highlight_card(card,true)

func on_hovered_off_card(card):
	highlight_card(card,false)

func highlight_card(card,hovered):
	if hovered:
		#print(card.get_child(0))
		var tween = create_tween()
		tween.tween_property(card.get_child(0), "position:y", initial_card_pos_y - 10, 0.05)
	else:
		var tween = create_tween()
		tween.tween_property(card.get_child(0), "position:y", initial_card_pos_y, 0.05)

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if !result.is_empty():
		return result[0].collider.get_parent()
	#return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
