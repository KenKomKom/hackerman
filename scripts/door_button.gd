extends Node3D

@export var door: Node3D
@export_enum("medium", "high") var type: String

var _can_interact = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# ganti texture
	if(get_parent().get_parent().id == 1):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_hospital.tres")
	elif(get_parent().get_parent().id == 2):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_bank.tres")
	elif(get_parent().get_parent().id == 3 and type == "medium"):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_ministry.tres")
	elif(get_parent().get_parent().id == 3 and type == "high"):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_ministry.tres")
	elif(get_parent().get_parent().id == 4 and type == "medium"):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_shadow.tres")
	elif(get_parent().get_parent().id == 4 and type == "high"):
		$fire.material_override = load("res://3dassets/envi/props/firewall/material/firewall_shadow.tres")

func _on_area_3d_body_entered(body):
	_can_interact = true

func _physics_process(delta):
	if _can_interact:
		if Input.is_action_just_pressed("ui_accept"):
			door.open_gate()
