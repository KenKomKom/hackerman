extends MarginContainer

@onready var dialogue_label =  $MarginContainer2/HBoxContainer/RichTextLabel
@onready var emote = $MarginContainer2/HBoxContainer/CenterContainer/TextureRect
@onready var dialoguebox = $TextureRect

var still_typing=false

signal go_to_next_line()

var rng:= RandomNumberGenerator.new()

func _ready():
	rng.randomize()

# Munculin satu satu huruf nya
func display_line(nama: String, dialogue:String, emosi):
	still_typing = true
	dialogue_label.visible_ratio=0.0
	dialogue_label.text=dialogue
	$MarginContainer.visible = false
	
	var type_speed : float = 1.0 / dialogue.length()
	var num = rng.randi_range(1,4)
	
	# TODO Atur sprite emosi
	emote.texture = load("res://2dassets/emoticon/"+nama+"-"+emosi+".png")
	if(nama == "h"):
		dialoguebox.texture = load("res://2dassets/dialoguebox/h.png")
	elif(nama == "sh" or nama == "sr"):
		dialoguebox.texture = load("res://2dassets/dialoguebox/s.png")
	
	# Munculin karakter satu per satu
	for characther in dialogue:
		dialogue_label.visible_ratio += type_speed
		await get_tree().create_timer(0.04).timeout
	still_typing = false
	$MarginContainer.visible = true

# Terima inout user buat lanjutin dialog
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and still_typing:
		dialogue_label.visible_ratio=1
		still_typing = false
		$MarginContainer.visible = true
	elif Input.is_action_just_pressed("ui_accept") and not still_typing:
		still_typing = false
		$MarginContainer.visible = true
		await get_tree().create_timer(0.0001).timeout #UNTUK MENJAMIN CONCURENCY AMAN
		emit_signal("go_to_next_line")

# TODO bikin input triangle nya gerak2
#func _physics_process(delta)
	#$MarginContainer.add_theme_constant_override("margin_top", 20)
	#$MarginContainer.add_theme_constant_override("margin_top", -20)
