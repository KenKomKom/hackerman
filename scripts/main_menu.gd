extends CanvasLayer

@onready var start_button = $TabContainer/Container/MarginContainer/CenterContainer/VBoxContainer/Button

@onready var level_4 = $TabContainer/LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/TextureButton5
@onready var level_grid = $TabContainer/LevelSelect/MarginContainer/VBoxContainer/HBoxContainer

var _started = false
var _select_level_displayed = false
var _save_select_displayed = false

@onready var _current_selected = $TabContainer/saveselect/MarginContainer/VBoxContainer/HBoxContainer/savebutton

func _ready():
	level_4.visible=false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and not _started:
		_on_start()
		_started=true
	
	# Dari level select ke Title
	elif _started and Input.is_action_just_released("esc"):
		_started=false
		_select_level_displayed=false
		level_4.visible=false
		$TabContainer.current_tab=0
		level_grid.set("theme_override_constants/separation", 0)
		_current_selected.set_selected(true)
	
	elif _save_select_displayed:
		_handle_change_selected()
		_handle_select()
	
	# Level select pilih level+animasi
	elif _select_level_displayed:
		if GameManager.level_unlocked[3]:
			level_grid.set("theme_override_constants/separation",  lerp(level_grid.get("theme_override_constants/separation"),40,0.04))
			$TabContainer/LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/TextureButton4.right = $TabContainer/LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/TextureButton5
		level_grid.set("theme_override_constants/separation",  lerp(level_grid.get("theme_override_constants/separation"),80,0.04))
		_handle_change_selected()
		_handle_select()

func _handle_change_selected():
	if Input.is_action_just_pressed("left") and _current_selected.left!=null :
		_current_selected.set_selected(false)
		_current_selected = _current_selected.left
		_current_selected.set_selected(true)
	if Input.is_action_just_pressed("right") and _current_selected.right!=null :
		_current_selected.set_selected(false)
		_current_selected = _current_selected.right
		_current_selected.set_selected(true)

func _handle_select():
	if Input.is_action_just_pressed("enter"):
		_current_selected.on_button_up()

func _on_start():
	for i in range(0,3):
		start_button.modulate=Color(1, 1, 1, 0)
		await get_tree().create_timer(0.1).timeout
		start_button.modulate=Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout
		start_button.modulate=Color(1, 1, 1, 0)
	await get_tree().create_timer(0.3).timeout
	$TabContainer.current_tab=1
	_set_up_saveselect()
	start_button.modulate=Color(1, 1, 1, 1)

func _set_up_saveselect():
	_save_select_displayed = true
	_current_selected = $TabContainer/saveselect/MarginContainer/VBoxContainer/HBoxContainer/savebutton
	_current_selected.set_selected(true)
	var save_select = $TabContainer/saveselect/MarginContainer/VBoxContainer/HBoxContainer
	var saves = save_select.get_children()
	for i in range(len(saves)):
		var save = saves[i]
		var save_info = GameManager.load_file_info(i)
		if save_info['exist']:
			save.set_status(i, save_info["level_finished"], save_info['player_name'])
	
	for i in range(0,2):
		await get_tree().create_timer(0.1).timeout
		save_select.modulate=Color(1, 1, 1, 0)
		await get_tree().create_timer(0.1).timeout
		save_select.modulate=Color(1, 1, 1, 1)
	await get_tree().create_timer(1).timeout

func _set_up_levelselect():
	_save_select_displayed = false
	_select_level_displayed = true
	_current_selected = $TabContainer/LevelSelect/MarginContainer/VBoxContainer/HBoxContainer/TextureButton
	_current_selected.set_selected(true)
	var levels = $TabContainer/LevelSelect/MarginContainer/VBoxContainer/HBoxContainer.get_children()
	var level_select = $TabContainer/LevelSelect/MarginContainer
	
	for i in range(len(levels)):
		levels[i].set_status(GameManager.anon_status[i], GameManager.best_time[i],GameManager.level_unlocked[i])
		if not GameManager.level_unlocked[i]:
			levels[i].disable_level()
	
	for i in range(0,2):
		await get_tree().create_timer(0.1).timeout
		level_select.modulate=Color(1, 1, 1, 0)
		await get_tree().create_timer(0.1).timeout
		level_select.modulate=Color(1, 1, 1, 1)
	await get_tree().create_timer(1).timeout
	if GameManager.level_unlocked[3]:
		level_4.visible=true
		await get_tree().create_timer(0.1).timeout
		level_4.modulate=Color(1, 1, 1, 0)
		await get_tree().create_timer(0.1).timeout
		level_4.modulate=Color(1, 1, 1, 1)

func _on_savebutton_button_up(id):
	GameManager.load_file(id)
	_set_up_levelselect()
	$TabContainer.current_tab=2
