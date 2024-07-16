extends MarginContainer

@onready var name_label = $MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/pembicara
@onready var dialogue_label =  $MarginContainer2/HBoxContainer/MarginContainer/VBoxContainer/dialogue
@onready var emote = $MarginContainer2/HBoxContainer/CenterContainer/TextureRect

var still_typing=false

signal go_to_next_line()

var rng:= RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func display_line(nama: String, dialogue:String, emosi):
	still_typing=true
	name_label.text = nama
	dialogue_label.visible_ratio=0.0
	dialogue_label.text=dialogue
	
	var type_speed = 1.2 / dialogue.length()
	var num = rng.randi_range(1,4)
	# TODO Atur sprite emosi
	
	# Munculin karakter satu per satu
	for characther in dialogue:
		dialogue_label.visible_ratio+=type_speed
		await get_tree().create_timer(0.01).timeout
	still_typing=false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and still_typing:
		dialogue_label.visible_ratio=1
		still_typing = false
	elif Input.is_action_just_pressed("ui_accept") and not still_typing:
		still_typing = false
		await get_tree().create_timer(0.0001).timeout #UNTUK MENJAMIN CONCURENCY AMAN, FUCK U
		emit_signal("go_to_next_line")
