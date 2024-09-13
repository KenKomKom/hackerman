extends Node

var last_playback_position: float

@onready var checkpoint = $Checkpoint
@onready var dialogue = $Dialogue
@onready var door_unlocked = $DoorUnlocked
@onready var firewall = $Firewall
@onready var bgm_ingame = $Ingame
@onready var bgm_menu = $MainMenu
@onready var robot_kill = $RobotKill
@onready var hacker_shout = $HackerShout
@onready var download = $Download
@onready var deathscreen = $DeathScreen
@onready var winscreen = $WinScreen

func _ready():
	pass

func _process(delta: float):
	pass
