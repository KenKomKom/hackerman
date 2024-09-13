extends Node3D

@export var id: int
@onready var main_camera = $Camera
@onready var zoom_out_camera = $Camera3D
@onready var dialogue_manager = $DialogueManager
@onready var audio_manager = $audio_manager

var player_original_pos: Vector3

func _ready():
	audio_manager.bgm_ingame.play(0.0)
	player_original_pos = $player.position
	
	#spawn at checkpoint klo uda reached
	if GlobalEvent.checkpoint_reached:
		$player.set_position($checkpoint.position + Vector3(1,0,0))
	
	#win condition
	GlobalEvent.connect("database_download_finish",finish_level)
	
	if !GlobalEvent.banner_activated:
		await get_tree().create_timer(4.5).timeout
		GlobalEvent.emit_signal("start_dialogue","res://dialogue/level "+str(id)+"/ingame begin.json")

# Atur camera
func _process(delta):
	pass

func finish_level():
	GlobalEvent.emit_signal("start_dialogue","res://dialogue/level "+str(id)+"/ingame end.json")
	await GlobalEvent.end_dialogue
	await get_tree().create_timer(0.25).timeout
	GlobalEvent.emit_signal("level_completed")
