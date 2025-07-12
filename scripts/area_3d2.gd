extends Area3D


@onready var top_plate = $platetest/Cube_001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("crates"):
		if global.player.is_holding_object() == false:
			top_plate.position.y -= 0.1
