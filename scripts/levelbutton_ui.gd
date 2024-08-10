extends Button

@export var id:=1
@export var level_name :=""
@export var hex_color = ""
@export var left :Button
@export var right :Button

var _unlocked

@onready var label_id = $VBoxContainer/TextureRect/id
@onready var level_image = $VBoxContainer/TextureRect
@onready var label_name = $VBoxContainer/TextureRect/name
@onready var label_anon_status = $VBoxContainer/MarginContainer/VBoxContainer/anon/HBoxContainer/VBoxContainer/anonimity_status
@onready var label_time_status = $VBoxContainer/MarginContainer/VBoxContainer/time/HBoxContainer/VBoxContainer/time_status

var target_image_prefix = "res://2dassets/level_ui/map/"

# Called when the node enters the scene tree for the first time.
func _ready():
	$selected.visible=false
	$disable.visible=false
	label_id.text="0"+str(id)
	level_image.texture=load(target_image_prefix+str(id)+".png")
	label_name.text = level_name
	label_id.set("theme_override_colors/font_color",  Color(hex_color))

func on_button_up():
	if _unlocked:
		TransitionLayer.change_scene("res://scenes/level.tscn")
		# TODO Kalo udh set up semua level ganti ke ini
		#TransitionLayer.change_scene("res://scenes/level"+str(id)+".tscn") 

func disable_level():
	$disable.visible=true

func set_status(new_anon, new_time, unlocked):
	label_anon_status.text = new_anon
	label_time_status.text = new_time
	_unlocked = unlocked

func set_selected(status):
	$selected.visible=status
