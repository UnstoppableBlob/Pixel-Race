extends Node3D

var player = null
var stage = 0
var first_time_picking_crate = null

signal stage_updated(stage_value)


func update_stage(new_stage_value: int):
	stage = new_stage_value
	emit_signal("stage_updated", stage)
