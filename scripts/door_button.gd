extends Node3D

class_name DoorButton

@export var door: Node3D
@export_enum("medium", "high") var type: String

@onready var object_of_interest:= $interactable/Node3D
@onready var mesh:= $buttonMesh
var unlocked = false
var level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent().get_parent().id
	
	# ganti texture
	if(level == 1):
		mesh.material_override = load("res://3dassets/envi/props/button/button_hospital_on.tres")
	elif(level == 2):
		mesh.material_override = load("res://3dassets/envi/props/button/button_bank_on.tres")
	elif(level == 3 and type == "medium"):
		mesh.material_override = load("res://3dassets/envi/props/button/button_ministry_on.tres")
	elif(level == 3 and type == "high"):
		mesh.material_override = load("res://3dassets/envi/props/button/button_high_ministry_on.tres")
	elif(level == 4 and type == "medium"):
		mesh.material_override = load("res://3dassets/envi/props/button/button_shadow_on.tres")
	elif(level == 4 and type == "high"):
		mesh.material_override = load("res://3dassets/envi/props/button/button_high_shadow_on.tres")

func interact():
	if !unlocked:
		door.interact()
		unlocked = true
		if(level == 1):
			mesh.material_override = load("res://3dassets/envi/props/button/button_hospital_off.tres")
		elif(level == 2):
			mesh.material_override = load("res://3dassets/envi/props/button/button_bank_off.tres")
		elif(level == 3 and type == "medium"):
			mesh.material_override = load("res://3dassets/envi/props/button/button_ministry_off.tres")
		elif(level == 3 and type == "high"):
			mesh.material_override = load("res://3dassets/envi/props/button/button_high_ministry_off.tres")
		elif(level == 4 and type == "medium"):
			mesh.material_override = load("res://3dassets/envi/props/button/button_shadow_off.tres")
		elif(level == 4 and type == "high"):
			mesh.material_override = load("res://3dassets/envi/props/button/button_high_shadow_off.tres")
