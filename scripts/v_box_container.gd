extends VBoxContainer

const WORLD = preload("res://scenes/world.tscn")

signal reset()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)
	global.level = 1
	global.is_reset = true
	global.dead = false
	reset.emit()


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)
	global.level = 1
	global.is_reset = true
	global.dead = false
	reset.emit()
	
