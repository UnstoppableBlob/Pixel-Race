extends Button

var tween := create_tween()
var original_size := size
var grow_size := Vector2(1.1, 1.1)


func grow_size_tween(end_size: Vector2, duration: float) -> void:
	tween.tween_property(self, 'size', end_size, duration)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)


func _on_mouse_entered() -> void:
	grow_size_tween(grow_size, .1)
