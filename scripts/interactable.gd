extends Area3D

@export_enum("sql", "download", "wipe", "deactivate", "hijack", "pickup", "interact") var command: String
@onready var text := $MeshInstance3D

var interacted := false
var can_interact:= false

func _ready():
	# Set albedo texture and color
	$MeshInstance3D.material_override = load("res://2dassets/interaction/material/"+command+".tres")
	text.visible = false

func _on_body_entered(body):
	if !interacted and body is Player:
		can_interact = true
		text.visible = true
		#print("player masuk")
	#if body is Enemy:

func _on_body_exited(body):
	if body is Player:
		can_interact = false
		text.visible = false
		print("player keluar")
	#if body is Enemy:
	
func _process(delta):
	
	if(command == "hijack"):
		if !interacted and can_interact and Input.is_action_just_released("hijack"):
			interacted = true
			get_parent().interact()
			
			can_interact = false
			text.transparency = 1
			text.visible = false
	elif(command == "sql"):
		if !interacted and can_interact and Input.is_action_just_released("sql inject"):
			interacted = true
			get_parent().interact()
			
			can_interact = false
			text.transparency = 1
			text.visible = false
	else:
		if !interacted and can_interact and Input.is_action_just_released("interact"):
			interacted = true
			get_parent().interact()
			
			can_interact = false
			text.transparency = 1
			text.visible = false
