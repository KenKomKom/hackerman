# Ini di run pas awal level

extends CanvasLayer

@onready var container = $Sprite2D
@onready var label = $Sprite2D/TextureRect/VBoxContainer
@onready var label_title = $Sprite2D/TextureRect/VBoxContainer/Label
@onready var label_mission = $Sprite2D/TextureRect/VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	label.visible=false
	
	#setup posisi
	container.position.x = -4000
	
	GlobalEvent.connect("level_start", activate_banner)

# Animasi dan masukin informasi level
func activate_banner():
	
	if(GlobalEvent.banner_activated):
		return
	
	get_tree().paused=true
	setup()
	
	GlobalEvent.banner_activated = true
	
	self.visible=true
	label.visible=true
	
	label.modulate.a = 0
	var start_position = container.position.x
	var fade_speed := 0.02
	var speed = 0.01
	var current_pos = 0
	
	#slide in masuk
	while current_pos < 1:
		current_pos += speed
		container.position.x = lerp(start_position,960.0,current_pos)
		await get_tree().create_timer(0.005).timeout
	await get_tree().create_timer(0.5).timeout
	
	#tulisannya muncul
	while label.modulate.a < 1:
		label.modulate.a += fade_speed
		await get_tree().create_timer(0.005).timeout
	await get_tree().create_timer(1).timeout
	
	#tulisannya fade out
	while label.modulate.a > 0:
		label.modulate.a -= fade_speed
		await get_tree().create_timer(0.005).timeout
	await get_tree().create_timer(0.25).timeout
	
	#slide out keluar
	current_pos = 0
	while current_pos < 1:
		current_pos += speed
		container.position.x = lerp(960.0,-start_position,current_pos)
		await get_tree().create_timer(0.005).timeout
	
	self.visible = false
	get_tree().paused = false

func setup():
	var id = GlobalEvent.current_level
	var level_name = GameManager.LEVEL_INFO[id]['title']
	var color = GameManager.LEVEL_INFO[id]['color']
	
	print(id," ",level_name," ",color)
	
	label_title.text = level_name.to_upper()
	label_title.set("theme_override_colors/font_color", Color(color))
	label_mission.text = "MISSION "+ str(id)
