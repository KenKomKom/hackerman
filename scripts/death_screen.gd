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

# Animasi setelah _set_up selesai
func _process(delta):
	if _is_dead:
		$TextureRect.modulate.a=lerp($TextureRect.modulate.a,1.0,0.2)
		if abs($TextureRect.modulate.a-1.0)>0.1:
			$VBoxContainer.visible = true
		if Input.is_action_just_released("esc"):
			get_tree().paused = false
			TransitionLayer.go_back_to_level_select()
		elif Input.is_action_just_released("ui_accept"):
			get_tree().paused = false
			get_tree().reload_current_scene()
