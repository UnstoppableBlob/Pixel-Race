extends Camera3D

@onready var camera = $"../../../Head/Camera3D"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform = camera.transform
