extends Node3D

var is_downloading = false

var downloading_canvas #canvasnya
var progress_number #progressbar
var progress_bar #textureprogressbar

func _ready():
	var mesh:= $Circle_002
	
	downloading_canvas = get_parent().get_node("Downloading_Bar")
	
	progress_number = downloading_canvas.get_node("DownloadingBar")
	progress_bar = downloading_canvas.get_node("TextureProgressBar")
	
	var level: int = get_parent().id
	
	if(level == 1):
		mesh.material_override = load("res://3dassets/envi/props/database/database_hospital.tres")
	elif(level == 2):
		mesh.material_override = load("res://3dassets/envi/props/database/database_bank.tres")
	elif(level == 3):
		mesh.material_override = load("res://3dassets/envi/props/database/database_ministry.tres")
	elif(level == 4):
		mesh.material_override = load("res://3dassets/envi/props/database/database_shadow.tres")

func _process(delta):
	pass

func download_data():
	if GlobalEvent.database_downloaded:
		return
	is_downloading = true
	await get_tree().create_timer(1).timeout
	if downloading_canvas:
		downloading_canvas.visible = visible
	
	var value = 0
	while value < 100 and is_downloading:
		value += 0.1
		#progress_number.value = floor(value)
		progress_number.value = value
		progress_bar.value = value
		await get_tree().create_timer(0.006).timeout
	#print(value)
	if value >= 100:
		print("harusnya database nya udah downloaded")
		GlobalEvent.database_downloaded = true
	downloading_canvas.visible = false
	#print("Data Downloaded")

func cancel_download():
	is_downloading = false
	#print("INITIATE DOWNLOAD CANCEL")
	
	progress_bar.value = 0
	downloading_canvas.visible = false
	
	var interactable = get_node("interactable")
	if interactable:
		interactable.can_interact = true
		interactable.text.visible = true
		#print("Download Canceled")

func interact():
	download_data()
	pass
