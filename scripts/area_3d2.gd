extends Area3D


@onready var top_plate = $platetest/Cube_001

var is_used: bool = false
var is_down = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("crates"):
		if global.player.is_holding_object() == false:
			top_plate.position.y -= 0.1
			is_down = true
			if !is_used:
				Transition.transition("plate")
				await Transition.on_transition_finished
				global.player.global_position.y = global_position.y + 5
				global.player.global_position.x = global_position.x
				global.player.global_position.z = global_position.z
				
				global.update_stage(global.stage + 1)
				print(global.level)

				print(is_used)
						
				print(global.stage)
				is_used = true
			if global.stage == 2:
				global.level += 1

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("crates"):
		if is_down:
			top_plate.position.y += 0.1
			is_down = false
			
