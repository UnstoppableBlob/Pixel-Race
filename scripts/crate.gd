extends Node3D

@onready var text = $SubViewport/Label

func _ready() -> void:
	visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global.stage == 2:
		text.text = "Try clicking on this block and clicking again to drop it."
		visible = true
	else:
		visible = false
		text.text = ""
