extends CanvasLayer

@onready var time_left = $time_remaining
@onready var progress_bar = $TextureProgressBar

func _ready():
	#hijack duration
	GlobalEvent.connect("player_is_hacking",countdown)
	GlobalEvent.connect("player_is_hacking", turn_on)
	GlobalEvent.connect("player_hacking_done", turn_off)

func _process(delta: float):
	pass

func countdown(node):
	var value = 10.0
	var fade_speed = 0.01
	
	print(value)
	
	while value > 0 and GlobalEvent.is_hacking:
		value -= fade_speed
		print(value)
		#progress_number.value = floor(value)
		time_left.text = str(floor(value / 10))+"s"
		progress_bar.value = value
		await get_tree().create_timer(fade_speed).timeout
	
	if !GlobalEvent.is_hacking:
		return
	
	GlobalEvent.is_hacking = false
	GlobalEvent.emit_signal("player_hacking_done")

func turn_on(node):
	visible = true

func turn_off():
	visible = false
