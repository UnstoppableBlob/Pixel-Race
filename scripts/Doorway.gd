extends Node3D

@onready var anim = $"door-rotate2/AnimationPlayer"

var open = false
var is_used = false
var exit = false

signal update_buttons()

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
		Transition.transition("doorway-forward", global_position.x,global_position.y,global_position.z)
		await Transition.on_transition_finished
		if !is_used:
			global.level += 1
			update_buttons.emit()
			print(global.level)
		is_used = true
		
func _on_reset():
	is_used = false
