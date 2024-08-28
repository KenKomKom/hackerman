extends Node3D

var unlocked = false
var is_downloading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func download_data():
	is_downloading = true
	await get_tree().create_timer(1).timeout
	var downloading_bar = get_parent().get_node("Downloading_Bar")
	if downloading_bar:
		downloading_bar.visible = visible
		
	var progress_bar = downloading_bar.get_node("DownloadingBar")
	var value = 0
	while value < 100 and is_downloading:
		value += 1
		progress_bar.value = value
		await get_tree().create_timer(0.06).timeout
	
	downloading_bar.visible = false
	print("Data Downloaded")

func cancel_download():
	is_downloading = false
	print("INITIATE DOWNLOAD CANCEL")
	var downloading_bar = get_parent().get_node("Downloading_Bar")
	var progress_bar = downloading_bar.get_node("DownloadingBar")
	progress_bar.value = 0
	downloading_bar.visible = false
	var interactable = get_node("interactable")
	if interactable:
		interactable.can_interact = true
		interactable.text.visible = true
		print("Download Canceled")

func interact():
	unlocked = true
	download_data()
	pass
