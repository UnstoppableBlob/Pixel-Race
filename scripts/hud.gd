extends Control

@onready var charge_meter = $CanvasLayer/ChargeMeter
@onready var stage_tracker = $CanvasLayer/StageTracker
@onready var stage_text = $CanvasLayer/StageTracker/Label

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	
	global.stage_updated.connect(_on_stage_updated)
	
	_on_stage_updated(global.stage)

	if player:
		player.charge_updated.connect(_on_charge_updated)
		player.holding_object.connect(_on_holding_object)
	charge_meter.visible = false


func _on_charge_updated(charge_value):
	charge_meter.value = charge_value


func _on_holding_object(is_holding):
	charge_meter.visible = is_holding
	

func _on_stage_updated(stage_value):
	stage_tracker.value = stage_value
	stage_text.text = "Stage: %s" % stage_value
