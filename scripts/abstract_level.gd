extends Node3D

@export var id: int
@onready var main_camera = $Camera
@onready var zoom_out_camera = $Camera3D
@onready var dm = $DialogueManager

var player_original_pos: Vector3

func _ready():
	GlobalEvent.emit_signal("start_dialogue", "res://dialogue/level 1/dialogue 1-ingame begin.json")
	#GlobalEvent.connect("level_start_prep", reset_checkpoint)
	
	player_original_pos = $player.position
	if GlobalEvent.checkpoint_reached:
		$player.set_position($checkpoint.position + Vector3(1,0,0))

# Atur camera
func _process(delta):
	pass
