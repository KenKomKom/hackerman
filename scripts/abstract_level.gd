extends Node3D

@export var id: int
@onready var main_camera = $Camera
@onready var zoom_out_camera = $Camera3D
@onready var dm = $DialogueManager

func _ready():
	GlobalEvent.emit_signal("start_dialogue", "res://dialogue/level 1/dialogue 1-ingame begin.json")

# Atur camera
func _process(delta):
	pass
