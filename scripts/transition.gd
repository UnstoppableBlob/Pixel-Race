extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var anim_player = $AnimationPlayer


func _ready():
	color_rect.visible = false
	anim_player.animation_finished.connect(_on_animation_finished)
	
	
func _on_animation_finished(anim_name):
	if anim_name == "fadetoblack":
		on_transition_finished.emit()
		if global.should_open == true:
			global.should_show_level_screen = true
		anim_player.play("fadetonormal")
	elif anim_name == "fadetonormal":
		color_rect.visible = false


func transition():
	color_rect.visible = true
	anim_player.play("fadetoblack")
	
	
