extends TextureRect

@export var cooldown :=3.0

@onready var timer = $Timer
@onready var sweep = $ProgressBar

func _ready():
	timer.wait_time = cooldown
	sweep.visible=false
	sweep.value = 100
	set_process(false)

# Update Cooldown
func _process(delta):
	sweep.value = int((timer.time_left / cooldown) * 100)

# Hilangin overlay cooldown
func _on_timer_timeout():
	sweep.visible=false
	sweep.value = 0
	set_process(false)

# function kalo abikity used
func _on_random_start_timeout():
	set_process(true)
	sweep.visible=true
	sweep.value=100
	timer.start()
