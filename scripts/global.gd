extends Node3D

var player = null
var stage = 0
var first_time_picking_crate = null
var level = 6
var should_open = false
var should_show_level_screen = false

@onready var pause_menu = $CanvasLayer/InputSettings
@onready var level_screen = $LevelSelectScreen

signal stage_updated(stage_value)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func update_stage(new_stage_value: int):
	stage = new_stage_value
	emit_signal("stage_updated", stage)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused 
		pause_menu.visible = get_tree().paused
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().root.get_viewport().set_input_as_handled()


func _on_level_select_screen_pause(pause: Variant) -> void:
	pass
		
