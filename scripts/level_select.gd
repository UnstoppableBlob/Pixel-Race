extends Control

@onready var level_buttons: Array[Button] = [] 

func _ready():
	for child in $CenterContainer/VBoxContainer/Row1.get_children():
		if child is Button:
			level_buttons.append(child)
	for child in $CenterContainer/VBoxContainer/Row2.get_children():
		if child is Button:
			level_buttons.append(child)

	level_buttons.sort_custom(func(a, b): return a.name < b.name)

	_update_level_buttons()

	for i in range(level_buttons.size()):
		var level_number = i + 1
		var button = level_buttons[i]
		button.pressed.connect(_on_level_button_pressed.bind(level_number))
		
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_level_menu"):
		visible = !visible


func _update_level_buttons():
	var current_unlocked_level = global.level

	for i in range(level_buttons.size()):
		var level_number = i + 1
		var button = level_buttons[i]
		var level_label = button.get_node("LevelNumber") as Label
		var lock_icon = button.get_node("LockIcon") as TextureRect

		if level_number <= current_unlocked_level:
			button.disabled = false
			lock_icon.visible = false
			level_label.text = str(level_number)
		else:
			button.disabled = true
			lock_icon.visible = true
			level_label.text = "" 


func _on_level_button_pressed(level_number: int):
	print("Level ", level_number, " selected!")
	pass


func unlock_next_level():
	global.level = max(1, global.level + 1)
	_update_level_buttons() 
	print("Unlocked up to level: ", global.level)


func set_level(new_level: int):
	global.level = max(1, new_level)
	_update_level_buttons()
	print("Set level to: ", global.level)
