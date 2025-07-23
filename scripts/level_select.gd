extends Control

@onready var level_buttons: Array[Button] = []

func _ready():
	for child in $CenterContainer/VBoxContainer/Row1.get_children():
		if child is Button:
			level_buttons.append(child)
	for child in $CenterContainer/VBoxContainer/Row2.get_children():
		if child is Button:
			level_buttons.append(child)

	level_buttons.sort_custom(func(a, b):
		var num_a = int(a.name.replace("LevelButton", ""))
		var num_b = int(b.name.replace("LevelButton", ""))
		return num_a < num_b
	)

	_on_update_buttons()


func _on_update_buttons():
	print("this is running", global.level, Time.get_date_dict_from_system())

	for i in range(level_buttons.size()):
		var level_number = i + 1
		var button = level_buttons[i]
		var level_label = button.get_node("LevelNumber") as Label
		var lock_icon = button.get_node("LockIcon") as TextureRect
		print("this is also running")

		if level_number <= global.level:
			button.disabled = false
			lock_icon.visible = false
			print("this is also also running")
			level_label.text = str(level_number)
		else:
			print("this is probably running")
			button.disabled = true
			lock_icon.visible = true
			level_label.text = ""


func unpause():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false


func _on_level_button_1_pressed() -> void:
	unpause()
	global.player.go_to(29, 15, 0)


func _on_level_button_2_pressed() -> void:
	unpause()
	global.player.go_to(97.2, 20, 4.824)


func _on_level_button_3_pressed() -> void:
	unpause()
	global.player.go_to()


func _on_level_button_4_pressed() -> void:
	unpause()
	global.player.go_to()


func _on_level_button_5_pressed() -> void:
	unpause()
	global.player.go_to()


func _on_level_button_6_pressed() -> void:
	unpause()
	global.player.go_to()


func _on_level_button_7_pressed() -> void:
	unpause()
	global.player.go_to()


func _on_level_button_8_pressed() -> void:
	unpause()
	global.player.go_to()


func _on_level_button_9_pressed() -> void:
	unpause()
	global.player.go_to()


func _on_level_button_10_pressed() -> void:
	unpause()
	global.player.go_to()
