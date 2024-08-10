extends Button

signal clicked(id)

var button_id
@export var left : Button
@export var right : Button

@onready var name_label = $VBoxContainer/Label
@onready var folder_image = $VBoxContainer/TextureRect
var _completed_level = 0

func _get_cleared(arr):
	var i = 0
	for x in (arr):
		if x:
			i+=1
	return i

func set_status(id, array_of_finished, owner_name):
	button_id = id
	disabled=false
	name_label.text = owner_name
	_completed_level = _get_cleared(array_of_finished)
	folder_image.texture = load("res://2dassets/save/file folder/"+str(_completed_level)+"-close.png")

func _on_v_box_container_mouse_entered():
	if button_id!=null:
		folder_image.texture = load("res://2dassets/save/file folder/"+str(_completed_level)+"-open.png")

func _on_v_box_container_mouse_exited():
	folder_image.texture = load("res://2dassets/save/file folder/"+str(_completed_level)+"-close.png")

func on_button_up():
	emit_signal("clicked", button_id)

func set_selected(status):
	$selected.visible=status
	if status and button_id!=null:
		folder_image.texture = load("res://2dassets/save/file folder/"+str(_completed_level)+"-open.png")
	else:
		folder_image.texture = load("res://2dassets/save/file folder/"+str(_completed_level)+"-close.png")
