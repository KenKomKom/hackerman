extends CanvasLayer

var _is_dead = false

func _ready():
	GlobalEvent.connect("level_completed", _set_up)

# Run ketika dapet signal player_is_dead
func _set_up():
	#kasih waktu sesuai animasi
	get_tree().paused=true
	_is_dead = true
	visible = true
	
	#setup label color
	var level: int = get_parent().id
	var color = GameManager.LEVEL_INFO[level]['color']
	$VBoxContainer/Label.set("theme_override_colors/font_color", Color(color))
	
	get_parent().audio_manager.winscreen.play(0.0)

# Animasi setelah _set_up selesai
func _process(delta):
	if _is_dead:
		$TextureRect.modulate.a = lerp($TextureRect.modulate.a,1.0,0.1)
		
		if abs($TextureRect.modulate.a - 1.0) > 0.1:
			$VBoxContainer.visible = true
		if Input.is_action_just_released("ui_accept"):
			get_tree().paused = false
			
			# -1 karena array mulai dari idx 0
			GameManager.level_finished[GlobalEvent.current_level-1] = true
			#if(GlobalEvent.current_level != 4):
			if(GlobalEvent.current_level == 1):
				GameManager.level_unlocked[GlobalEvent.current_level] = true
			# level 3 block dulu aja
			
			GameManager.save_file()
			
			TransitionLayer.change_scene("res://scenes/article.tscn")
