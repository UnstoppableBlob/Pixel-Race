extends Area3D



func _on_body_entered(body: Node3D) -> void:
	print(global.one)
	global.one = false


func _on_body_exited(body: Node3D) -> void:
	global.one = true
	print(global.one)
	print(global.one)
