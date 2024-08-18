extends Camera3D

@export var target:Node3D
@export var speed:=5.0

@onready var reset_rotation_timer = $"Timer"

var relative = 0.0
var player_idle=true

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEvent.connect("player_move", handle_player_move)

# Follow target umumnya player
func _physics_process(delta):
	if player_idle:
		relative= lerp(relative,0.0,0.1)
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,88,rotation_degrees.z), 0.5)
	if target!=null:
		var target_dir = (target.global_position - self.global_position).normalized()
		global_position.x = (lerp(global_position.x, target.global_position.x+5, delta*speed))
		global_position.z = (lerp(global_position.z+(relative*0.1), target.global_position.z, delta*speed))

# Offset camera kalo di kejar
func handle_player_move(dir):
	reset_rotation_timer.start()
	if GameManager.player_chased and dir=="left":
		player_idle=false
		relative= lerp(relative,-2.0,0.5)
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,94,rotation_degrees.z), 0.5)
	elif GameManager.player_chased and dir=="right":
		player_idle=false
		relative= lerp(relative,2.0,0.5)
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,82,rotation_degrees.z), 0.5)
	else:
		relative= lerp(relative,0.0,0.5)
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,88,rotation_degrees.z), 0.5)

func _on_timer_timeout():
	player_idle=true
