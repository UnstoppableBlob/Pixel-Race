extends Node3D

var player = null
var stage = 0
var first_time_picking_crate = null

@onready var pause_menu = $CanvasLayer/InputSettings

var game_paused = false

signal stage_updated(stage_value)


func update_stage(new_stage_value: int):
	stage = new_stage_value
	emit_signal("stage_updated", stage)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
		if game_paused:
			Engine.time_scale = 0
			pause_menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Engine.time_scale = 1
			pause_menu.visible = false
		get_tree().root.get_viewport().set_input_as_handled()
