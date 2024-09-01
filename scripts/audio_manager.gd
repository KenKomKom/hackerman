extends Node

#signal start_sfx(file_path)
#signal start_bgm(file_path)

var last_playback_position: float

@onready var checkpoint = $Checkpoint
@onready var dialogue = $Dialogue
@onready var door_unlocked = $DoorUnlocked
@onready var firewall = $Checkpoint
@onready var bgm_ingame = $Ingame
@onready var bgm_menu = $MainMenu
@onready var robot_kill = $RobotKill
@onready var download = $download
@onready var deathscreen = $DeathScreen
@onready var winscreen = $WinScreen

func _ready() -> void:
	#bgm_menu.loop = true
	#bgm_ingame.loop = true
	pass

func _process(delta: float) -> void:
	pass
#
#func _on_start_bgm() -> void:
	#pass
#
#func _on_start_sfx() -> void:
	#pass
