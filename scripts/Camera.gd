extends Camera3D

@export var target:Node3D
@export var speed:= 5.0

@onready var reset_rotation_timer = $"Timer"

var relative = 0.0
var player_idle = true

# Called when the node enters the scene tree for the first time.
func _ready():
	target = $"../player"
	GlobalEvent.connect("player_move", handle_player_move)
	GlobalEvent.connect("player_is_hacking",change_focus_to_hacked)
	GlobalEvent.connect("player_hacking_done",change_focus_to_player)

# Follow target umumnya player
func _physics_process(delta):
	if player_idle:
		relative= lerp(relative,0.0,0.1)
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,88.5,rotation_degrees.z), 0.5)
	
	if target!=null:
		var target_dir = (target.global_position - self.global_position).normalized()
		global_position.x = (lerp(global_position.x, target.global_position.x+5, delta*speed))
		global_position.z = (lerp(global_position.z+(relative*0.1), target.global_position.z, delta*speed))

# Offset camera kalo di kejar
func handle_player_move(dir):
	reset_rotation_timer.start()
	
	relative= lerp(relative,0.0,0.5)
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,90,rotation_degrees.z), 0.5)
	
	#if GameManager.player_chased and dir=="left":
		#player_idle=false
		#relative= lerp(relative,-2.0,0.5)
		#var tween = create_tween()
		#tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,94,rotation_degrees.z), 0.5)
	#elif GameManager.player_chased and dir=="right":
		#player_idle=false
		#relative= lerp(relative,2.0,0.5)
		#var tween = create_tween()
		#tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,82,rotation_degrees.z), 0.5)
	#else:
		#relative= lerp(relative,0.0,0.5)
		#var tween = create_tween()
		#tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x,90,rotation_degrees.z), 0.5)

func _on_timer_timeout():
	player_idle = true

func change_focus_to_hacked(node: Node3D):
	target = node
	
func change_focus_to_player():
	#target = $"../player"
	target = get_parent().get_node("player")
