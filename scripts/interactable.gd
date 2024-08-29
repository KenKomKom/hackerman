extends Area3D

@export_enum("sql", "download", "wipe", "deactivate", "hijack", "pickup", "interact", "checkpoint") var command: String
@onready var text := $MeshInstance3D

var interacted := false
var can_interact:= false
var enemy_interact:= false
var player: Player
var is_downloading: bool = false
var database_script: Node

func _ready():
	# Set albedo texture and color
	$MeshInstance3D.material_override = load("res://2dassets/interaction/material/"+command+".tres")
	text.visible = false
	database_script = get_parent()

func _on_body_entered(body):
	if command == "download" and GlobalEvent.database_downloaded:
		return
	if command == "checkpoint" and GlobalEvent.checkpoint_reached:
		return
	
	#klo player yg masuk
	if !interacted and body is Player:
		player = body
		can_interact = true
		text.visible = true
		#print("player masuk")
	
	#klo enemy yg masuk
	if (!interacted) and (GlobalEvent.is_hacking) and (body is Enemy) and (get_parent() is DoorButton):
		#klo door button yg medium
		print(get_parent().type)
		if(get_parent().type == "medium"):
			enemy_interact = true
			text.position += Vector3(0,0.5,0)
			text.visible = true
		#klo door button yg high
		elif(get_parent().type == "high" and body is EnemyHigh):
			enemy_interact = true
			text.position += Vector3(0,0.5,0)
			text.visible = true
		print(text.visible)

func _on_body_exited(body):
	if body is Player:
		can_interact = false
		text.visible = false
		#print("player keluar")
	if GlobalEvent.is_hacking and body is Enemy:
		enemy_interact = false
		text.visible = false
		if(get_parent() is DoorButton):
			text.position -= Vector3(0,0.5,0)

func _process(delta):
	#cek input, kasi input jenis animasi based on command
	if enemy_interact and Input.is_action_just_pressed("interact"):
		interact("enemy")
		return
	
	if(command == "hijack") and Input.is_action_just_pressed("hijack"):
		interact_hijack()
	elif(command == "sql") and Input.is_action_just_pressed("sql inject"):
		interact("interact")
	elif Input.is_action_just_pressed("interact"):
		if command == "pickup" or command == "checkpoint" or command == "interact":
			interact("interact")
		elif command == "deactivate":
			interact("hack")
		elif command == "download" or command == "wipe":
			if not is_downloading and can_interact:
				is_downloading = true
				print("DOWNLOADING")
				download()
	
	elif is_downloading and not Input.is_action_pressed("interact"):
		# If the button is released during download
		if !GlobalEvent.database_downloaded:
			print("DOWNLOADING INTERUPTED")
			is_downloading = false
			database_script.cancel_download()
			#player.stop_animation()  # Assuming you have a method to stop the animation
			

func interact(animation: String):
	if command == "hijack":
		return
	if command == "download" and GlobalEvent.database_downloaded:
		return
	
	if !interacted and enemy_interact:
		interacted = true
		get_parent().interact()
		can_interact = false
		text.visible = false
	
	if !interacted and can_interact:
		interacted = true
		get_parent().interact()
		can_interact = false
		text.visible = false

func interact_hijack():
	if !can_interact:
		return
	print("interact hijack dh jalan")
	if command != "hijack" or GlobalEvent.is_hacking:
		print("keluar woi ini bukan hijack")
		return
	
	var enemy = get_parent().get_parent().get_parent().get_parent()
	#if(enemy.current_state.name == "chasing"):
		#return
	
	player.update_animation("hijack")
	enemy.interact()
	
	can_interact = false
	text.visible = false

# Nevlin Added
func download():
	if command != "download" and command != "wipe":
		return
	if (command == "download" or command == "wipe") and GlobalEvent.database_downloaded:
		return
	if (command == "download" or command == "wipe") and can_interact:
		interacted = true
		player.update_animation("download")
		get_parent().interact()
		can_interact = false
		text.visible = false
