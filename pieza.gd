extends Node2D

signal pieza_seleccionada(pieza)
@onready var ruta_icono = $Icono
var id_casilla := -1
var tipo : int 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func cargar_icono(nombre_pieza):
	ruta_icono.texture = load(DataHandler.assets[nombre_pieza])


func _on_icono_gui_input(event):
	if event.is_action_pressed("clic_izquierdo"):
		emit_signal("pieza_seleccionada", self)
