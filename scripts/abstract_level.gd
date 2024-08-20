extends Node3D
@onready var main_camera = $Camera
@onready var zoom_out_camera = $Camera3D
@onready var dm = $DialogueManager

func _ready():
	GlobalEvent.emit_signal("start_dialogue", "res://testing.json")

# Atur camera
func _process(delta):
	#print_debug($firewalls/firewall.global_position)
	#print_debug($firewalls/firewall2.global_position)
	#print_debug($firewalls/firewall3.global_position)
	#print_debug($firewalls/firewall4.global_position)
	#print_debug($player.global_position)
	
	if Input.is_action_just_released("camera"):
		if main_camera.current:
			zoom_out_camera.make_current()
		else:
			main_camera.make_current()
