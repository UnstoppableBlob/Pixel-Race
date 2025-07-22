extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer

var called_by = null
var positionx = null
var positiony = null
var positionz = null

func _ready():
	color_rect.visible = false
	anim_player.animation_finished.connect(_on_animation_finished)
	
	
func _on_animation_finished(anim_name):
	if anim_name == "fadetoblack":
		if called_by == "doorway-forward":
			global.player.global_position.x = positionx + 13
			global.player.global_position.y = positiony + 15.9
			global.player.global_position.z = positionz
			global.player.head.rotation.y = 67.5
		if called_by == "doorway-back":
			global.player.global_position.x = positionx - 13
			global.player.global_position.y = positiony - 13
			global.player.global_position.z = positionz
			global.player.head.rotation.y = -67.5
		on_transition_finished.emit()
		anim_player.play("fadetonormal")
	elif anim_name == "fadetonormal":
		color_rect.visible = false


func transition(caller, coordsx=null, coordsy=null, coordsz=null):
	called_by = caller
	if caller == "doorway-forward":
		positionx = coordsx
		positiony = coordsy
		positionz = coordsz
	elif caller == "doorway-back":
		positionx = coordsx
		positiony = coordsy
		positionz = coordsz
	color_rect.visible = true
	anim_player.play("fadetoblack")
	
	
