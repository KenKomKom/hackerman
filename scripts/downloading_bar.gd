extends CanvasLayer

func _ready() -> void:
	var level: int = get_parent().id
	var texturebar = $TextureProgressBar
	
	# ganti texture
	if(level == 1):
		texturebar.set_under_texture(load("res://2dassets/progress bar/hospital_progressbar.png"))
		texturebar.set_progress_texture(load("res://2dassets/progress bar/hospital_progressbar_progress.png"))
	elif(level == 2):
		texturebar.set_under_texture(load("res://2dassets/progress bar/bank_progressbar.png"))
		texturebar.set_progress_texture(load("res://2dassets/progress bar/bank_progressbar_progress.png"))
		$RichTextLabel.text = "      Wiping"
	elif(level == 3):
		texturebar.set_under_texture(load("res://2dassets/progress bar/ministry_progressbar.png"))
		texturebar.set_progress_texture(load("res://2dassets/progress bar/ministry_progressbar_progress.png"))
	elif(level == 4):
		texturebar.set_under_texture(load("res://2dassets/progress bar/shadow_progressbar.png"))
		texturebar.set_progress_texture(load("res://2dassets/progress bar/shadow_progressbar_progress.png"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
