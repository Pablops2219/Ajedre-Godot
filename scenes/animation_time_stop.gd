extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("time_stop")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass