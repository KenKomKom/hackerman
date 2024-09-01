extends CanvasLayer

var _is_dead = false

func _ready():
	GlobalEvent.connect("player_is_dead", _set_up)

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

# Animasi setelah _set_up selesai
func _process(delta):
	if _is_dead:
		$TextureRect.modulate.a = lerp($TextureRect.modulate.a,1.0,0.1)
		
		if abs($TextureRect.modulate.a - 1.0) > 0.1:
			$VBoxContainer.visible = true
			
		if Input.is_action_just_released("ui_accept"):
			await get_tree().create_timer(0.15).timeout
			get_tree().paused = false
			get_tree().reload_current_scene()

		elif Input.is_action_just_released("esc"):
			get_tree().paused = false
			TransitionLayer.go_back_to_level_select()
