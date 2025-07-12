extends Area3D

var player_in_area: CharacterBody3D = null

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_area = body as CharacterBody3D
		


func _on_body_exited(body: Node3D) -> void:
	if body == player_in_area:
		player_in_area = null


func _physics_process(delta: float) -> void:
	if player_in_area != null:
		if Input.is_action_just_pressed("spacebar"):
			player_in_area.jump()
