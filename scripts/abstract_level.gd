extends Node3D
@onready var main_camera = $Camera
@onready var zoom_out_camera = $Camera3D

# Atur camera
func _process(delta):
	if Input.is_action_just_released("camera"):
		if main_camera.current:
			zoom_out_camera.make_current()
		else:
			main_camera.make_current()
