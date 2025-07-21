extends Node3D

@onready var anim = $"door-rotate2/AnimationPlayer"

var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_distance_checker_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if !open:
			anim.play("open")
			open = true


func _on_distance_checker_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if open:
			anim.play("close")
			open = false


func _on_inside_checker_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Transition.transition()
		await Transition.on_transition_finished
