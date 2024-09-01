extends CanvasLayer

@onready var input_ui := $input_ui
var current_level: int

func _ready():
	input_ui.visible = false
	input_ui.modulate.a = 0
	current_level =  GlobalEvent.current_level
	
	$audio_manager.bgm_menu.play(AudioManager.last_playback_position)
	
	GlobalEvent.connect("end_dialogue", enable_ui)
	setup_dialogue()
	
	if(current_level == 1):
		$"mission brief".texture = load("res://2dassets/briefing_screen/Waitlist General.png")
	elif(current_level == 2):
		$"mission brief".texture = load("res://2dassets/briefing_screen/Debitus Bank.png")
	elif(current_level == 3):
		$"mission brief".texture = load("res://2dassets/briefing_screen/Ministry of Defense.png")
	elif(current_level == 4):
		$"mission brief".texture = load("res://2dassets/briefing_screen/Shadow Corp.png")

func _process(delta: float):
	#klo dialog blom selesai, gbs mulai
	if (!input_ui.visible):
		return
	
	#balik ke menu select level
	if Input.is_action_just_released("esc"):
		#await get_tree().create_timer(0.0001).timeout
		TransitionLayer.go_back_to_level_select()
	
	#masuk ke level, tergantung current level nya berapa
	if Input.is_action_just_released("enter"):
		TransitionLayer.change_scene("res://scenes/levels/level_"+str(current_level)+".tscn")

func setup_dialogue():
	await get_tree().create_timer(0.75).timeout
	GlobalEvent.emit_signal("start_dialogue", "res://dialogue/level "+str(current_level)+"/pregame.json")

func enable_ui():
	input_ui.visible = true
	
	await get_tree().create_timer(0.15).timeout
	
	var fade_speed := 0.01
	while input_ui.modulate.a < 1:
		input_ui.modulate.a += fade_speed
		await get_tree().create_timer(0.005).timeout
