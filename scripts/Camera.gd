extends Camera3D

@export var target:Node3D
@export var speed:=5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEvent.connect("player_move", handle_player_move)
	
func _process(delta):
	if target!=null:
		var target_dir = (target.global_position - self.global_position).normalized()
		#position += speed * target_dir * delta
		global_position.x = (lerp(global_position.x, target.global_position.x+5, delta*speed))
		global_position.z = (lerp(global_position.z, target.global_position.z, delta*speed))
	
func handle_player_move(dir):
	if dir=="left":
		pass
	elif dir=="rigth":
		pass
	else:
		pass
