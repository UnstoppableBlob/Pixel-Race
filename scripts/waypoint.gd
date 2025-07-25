extends Node3D

var cam

@onready var origin = $origin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam = get_viewport().get_camera_3d()


func _process(delta: float) -> void:
	var markerPos = cam.unproject_position(self.global_transform.origin)
	origin.position = markerPos
	
	if $VisibleOnScreenNotifier3D.is_on_screen():
		origin.show()
	else:
		origin.hide()
