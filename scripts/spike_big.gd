extends Node3D


@export var fling_strength: float = 100.0

@export var target_node: CharacterBody3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var rigid_body = body as RigidBody3D
		
		if target_node:
			var direct_target = (target_node.global_position - rigid_body.global_position).normalized()
			rigid_body.apply_central_impulse(direct_target * fling_strength)
			print("worked")
		else:
			print("target_node isn't assigned")
	else:
		print("entered but no rigidbody")
