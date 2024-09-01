extends Node3D

@onready var mesh:= $checkpoint
@onready var object_of_interest = $checkpoint
var level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent().id
	
	# ganti texture
	if GlobalEvent.checkpoint_reached:
		if(level == 1):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_hospital.tres")
		elif(level == 2):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_bank.tres")
		elif(level == 3):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_ministry.tres")
		elif(level == 4):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_shadow.tres")
	else:
		if(level == 1):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_hospital_off.tres")
		elif(level == 2):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_bank_off.tres")
		elif(level == 3):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_ministry_off.tres")
		elif(level == 4):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_shadow_off.tres")

func interact():
	if !GlobalEvent.checkpoint_reached:
		# mo infoin bahwa checkpoint reached
		$"../audio_manager".checkpoint.play(0.0)
		GlobalEvent.checkpoint_reached = true
		
		if(level == 1):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_hospital.tres")
		elif(level == 2):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_bank.tres")
		elif(level == 3):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_ministry.tres")
		elif(level == 4):
			mesh.material_override = load("res://3dassets/envi/props/checkpoint/checkpoint_shadow.tres")
