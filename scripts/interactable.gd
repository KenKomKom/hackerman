extends Area3D

@export_enum("sql", "download", "wipe", "deactivate", "hijack", "pickup", "interact") var command: String
@onready var text := $MeshInstance3D

var interacted := false
var can_interact:= false
var player: Player

func _ready():
	# Set albedo texture and color
	$MeshInstance3D.material_override = load("res://2dassets/interaction/material/"+command+".tres")
	text.visible = false

func _on_body_entered(body):
	if !interacted and body is Player:
		player = body
		can_interact = true
		text.visible = true
		#print("player masuk")
	#if body is Enemy:

func _on_body_exited(body):
	if body is Player:
		can_interact = false
		text.visible = false
		#print("player keluar")
	#if body is Enemy:
	
func _process(delta):
	#cek input, kasi input jenis animasi based on command
	if(command == "hijack") and Input.is_action_just_pressed("hijack"):
		interact("hack")
	elif(command == "sql") and Input.is_action_just_pressed("sql inject"):
		interact("interact")
	elif Input.is_action_just_pressed("interact"):
		if command == "pickup" or command == "interact":
			interact("interact")
		elif command == "deactivate":
			interact("hack")
		elif command == "download" or command == "wipe":
			interact("download")

func interact(animation: String):
	if !interacted and can_interact:
		interacted = true
		player.update_animation(animation)
		get_parent().interact()
		can_interact = false
		text.visible = false
