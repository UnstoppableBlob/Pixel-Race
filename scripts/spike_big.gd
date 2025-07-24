extends Node3D


@export var fling_strength: float = 100.0

#@export var target_node: CharacterBody3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var rigid_body = body as RigidBody3D
		
		var random_direction = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		
		rigid_body.apply_central_impulse(random_direction * fling_strength)
		#if target_node:
			#var direct_target = (target_node.global_position - rigid_body.global_position).normalized()
			#rigid_body.apply_central_impulse(direct_target * fling_strength)
		
		# ^ this code is just what I had earlier. I am trying to figure out how to make the player take knockback from this, but I'll figure that out later
		
