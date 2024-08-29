# Ini di run pas awal level

extends CanvasLayer

@onready var label_title = $ColorRect/VBoxContainer/Label
@onready var label_mission = $ColorRect/VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	label_title.visible=false
	label_mission.visible=false
	GlobalEvent.connect("level_start", set_up)

# Animasi dan masukin informasi level
func set_up(level_name, level_id, color):
	print("ini kenapa print tp yg tadi nggak")
	get_tree().paused=true
	self.visible=true
	label_title.text = level_name.to_upper()
	label_title.set("theme_override_colors/font_color", Color(color))
	label_mission.text = "MISSION "+ str(level_id)
	label_title.visible=true
	label_mission.visible=true
	for i in range(0,3):
		label_title.modulate=Color(1, 1, 1, 0)
		label_mission.modulate=Color(1, 1, 1, 0)
		await get_tree().create_timer(0.1).timeout
		label_title.modulate=Color(1, 1, 1, 1)
		label_mission.modulate=Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(1).timeout
	for i in range(0,3):
		$ColorRect.modulate=Color(1, 1, 1, 0)
		await get_tree().create_timer(0.1).timeout
		$ColorRect.modulate=Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout
	self.visible=false
	get_tree().paused=false
