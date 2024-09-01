extends CanvasLayer

@onready var input_ui := $input_ui
var current_level: int

func _ready():
	input_ui.visible = false
	input_ui.modulate.a = 0
	current_level =  GlobalEvent.current_level
	
	GlobalEvent.connect("end_dialogue", enable_ui)
	setup_dialogue()
	
	if(current_level == 1):
		$article.texture = load("res://2dassets/postgame_article/postgame 1.png")
		$input_ui.texture = load("res://2dassets/mainmenu_ui/1_continue.png")
	elif(current_level == 2):
		$article.texture = load("res://2dassets/postgame_article/postgame 2.png")
		$input_ui.texture = load("res://2dassets/mainmenu_ui/2_continue.png")
	elif(current_level == 3):
		$article.texture = load("res://2dassets/postgame_article/postgame 3.png")
		$input_ui.texture = load("res://2dassets/mainmenu_ui/3_continue.png")
	elif(current_level == 4):
		$article.texture = load("res://2dassets/postgame_article/postgame 4.png")
		$input_ui.texture = load("res://2dassets/mainmenu_ui/4_continue.png")

func _process(delta: float):
	#klo dialog blom selesai, gbs mulai
	if (!input_ui.visible):
		return
	
	#balik ke menu select level
	if Input.is_action_just_released("enter"):
		#await get_tree().create_timer(0.0001).timeout
		TransitionLayer.go_back_to_level_select()

func setup_dialogue():
	await get_tree().create_timer(0.75).timeout
	GlobalEvent.emit_signal("start_dialogue", "res://dialogue/level "+str(current_level)+"/postgame.json")

func enable_ui():
	input_ui.visible = true
	
	await get_tree().create_timer(0.15).timeout
	
	var fade_speed := 0.01
	while input_ui.modulate.a < 1:
		input_ui.modulate.a += fade_speed
		await get_tree().create_timer(0.005).timeout
