extends CanvasLayer

func _ready() -> void:
	GlobalEvent.connect("player_is_hacking", turn_on)
	GlobalEvent.connect("player_hacking_done", turn_off)
	
	visible = false
func _process(delta: float) -> void:
	pass

func turn_on(node):
	visible = true

func turn_off():
	visible = false
