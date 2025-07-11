extends Camera3D

@onready var player = $"../../.."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Vector3(player.position.x, player.position.y + 1.75, player.position.z)
