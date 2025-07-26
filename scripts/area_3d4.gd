extends Area3D

var rigid = null
var yes

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		rigid = body
		#body.apply_central_impulse(Vector3(0, 10, 0))
		print("works")
		yes = true


func _on_body_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		yes = false


func _process(delta: float) -> void:
	if yes:
		if rigid:
			rigid.apply_central_impulse(Vector3(0, -0.05, 0))
