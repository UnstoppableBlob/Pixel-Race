extends Control

@onready var charge_meter = $CanvasLayer/ChargeMeter

func _ready():
	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.charge_updated.connect(_on_charge_updated)
		player.holding_object.connect(_on_holding_object)
	charge_meter.visible = false


func _on_charge_updated(charge_value):
	charge_meter.value = charge_value


func _on_holding_object(is_holding):
	charge_meter.visible = is_holding
