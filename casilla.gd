extends ColorRect

@onready var ruta_filtro = $Filtro
var id_casilla := -1
signal casilla_seleccionada(casilla)
var estado = DataHandler.estado_casillas.Vacia

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_color_fondo(c) -> void:
	color = c

func set_filtro(color = DataHandler.estado_casillas.Ninguno):
	estado = color
	match color:
		DataHandler.estado_casillas.Ninguno:
			ruta_filtro.color = Color(0,0,0,0)
		DataHandler.estado_casillas.Vacia:
			ruta_filtro.color = Color(0,1,0,0.4)

func _on_filtro_gui_input(event):
	if event.is_action_pressed("clic_izquierdo"):
		emit_signal("casilla_seleccionada", self)
