extends Node3D

@onready var anim = $"door-rotate2/AnimationPlayer"

var open = false


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
		Transition.transition("doorway-back", global_position.x, global_position.y, global_position.z)
		await Transition.on_transition_finished
