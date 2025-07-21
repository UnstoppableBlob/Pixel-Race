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

	_update_level_buttons()


func _update_level_buttons():
	var current_unlocked = global.level

	for i in range(level_buttons.size()):
		var level_number = i + 1
		var button = level_buttons[i]
		var level_label = button.get_node("LevelNumber") as Label
		var lock_icon = button.get_node("LockIcon") as TextureRect

		if level_number <= current_unlocked:
			button.disabled = false
			lock_icon.visible = false
			level_label.text = str(level_number)
		else:
			button.disabled = true
			lock_icon.visible = true
			level_label.text = ""
