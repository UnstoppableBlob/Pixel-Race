extends Node3D

var player = null
var stage = 0
var first_time_picking_crate = null
var level = 6


@onready var pause_menu = $CanvasLayer/InputSettings
@onready var level_screen = $LevelSelectScreen

signal stage_updated(stage_value)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func update_stage(new_stage_value: int):
	stage = new_stage_value
	emit_signal("stage_updated", stage)


func toggle_level_screen():
	var is_opening = !level_screen.visible
	level_screen.visible = is_opening
	get_tree().paused = is_opening 

	if is_opening:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if level_screen.visible:
			return
		
		get_tree().paused = !get_tree().paused
		pause_menu.visible = get_tree().paused
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().root.get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("open_level_menu"):
		toggle_level_screen()
		get_tree().root.get_viewport().set_input_as_handled()
