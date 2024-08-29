extends Button

@export var id:=1
@export var left :Button
@export var right :Button

var _unlocked

# perlu pas nanti masuk ke level
var level_name :="" 
var hex_color = "" 

@onready var label_id = $VBoxContainer/TextureRect/id
@onready var level_image = $VBoxContainer/TextureRect
@onready var label_name = $VBoxContainer/TextureRect/name
@onready var label_anon_status = $VBoxContainer/MarginContainer/MarginContainer2/VBoxContainer/anon/HBoxContainer/VBoxContainer/anonimity_status
@onready var label_time_status = $VBoxContainer/MarginContainer/MarginContainer2/VBoxContainer/time/HBoxContainer/VBoxContainer/time_status

var _target_image_prefix = "res://2dassets/level_ui/map/"

func _ready():
	$selected.visible=false
	$disable.visible=false
	
	level_name = GameManager.LEVEL_INFO[id]['title']
	hex_color = GameManager.LEVEL_INFO[id]['color']
	
	label_id.text="0"+str(id)
	level_image.texture=load(_target_image_prefix+str(id)+".png")
	label_name.text = level_name.to_upper()
	label_id.set("theme_override_colors/font_color",  Color(hex_color))

# Mainin level
func on_button_up():
	if _unlocked:
		TransitionLayer.change_scene("res://scenes/levels/level_1.tscn, level_name, id, hex_color")
		
		# TODO Kalo udh set up semua level ganti ke bawah ini
		#TransitionLayer.change_scene("res://scenes/level"+str(id)+".tscn") 

# Kalo bisa mainin di enable
func _disable_level(status):
	$disable.visible=not status

# Tulis info time, status level kalo udh enable
func set_status(new_anon, new_time, unlocked):
	print(new_anon, new_time, unlocked, label_anon_status)
	label_anon_status.text = new_anon
	label_time_status.text = new_time
	_unlocked = unlocked
	_disable_level(_unlocked)

# Nyalain texture selected kalo difocus
func set_selected(status):
	$selected.visible=status
