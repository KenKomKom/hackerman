extends enemy_state

class_name enemy_hacked_state

@onready var ray = $"../../RayCast3D"
#@onready var timer = $Timer
@onready var mesh_node = $"../../low tier/antivirus low/Skeleton3D"
@export var tile_size = 1

# untuk mengontrol player bisa berjalan atau tidak. (ex: buka kotak sampah player tidak bisa gerak)
var can_move = true
var moving = false #state sedang gerak

var ease_move = 0 #timer buat forced dir gerak
var forced_dir = "stand" # input yg masuk tengah gerak
var last_dir = "stand" # arah terakhir gerak
var target_position_after_move :Vector3

func ready_state():
	#parent_enemy.position.x = parent_enemy.position.snapped(Vector3.ONE * tile_size).x
	#parent_enemy.position.z = parent_enemy.position.snapped(Vector3.ONE * tile_size).z
	#parent_enemy.position += Vector3(1,0,1) * tile_size / 2
	parent_enemy.setup_texture_hacked()
	#print(anim_player.current_animation)

func do_something(delta):
	# klo lg dialog, gbs gerak
	if GlobalEvent.stop_for_dialogue:
		return
	#print(parent_enemy.current_state,parent_enemy.hacked)
	if(GlobalEvent.is_hacking and parent_enemy.hacked):
		move(delta)

var inputs = {"right": Vector3(0,0,-1),
			"left": Vector3(0,0,1),
			"up": Vector3(-1,0,0),
			"down": Vector3(1,0,0),
			"stand" : Vector3(0,0,0)}

func _physics_process(delta):
	if(GlobalEvent.is_hacking):
		move(delta)
		if(Input.is_action_just_released("esc")): 
			GlobalEvent.is_hacking = false
			#parent_enemy.change_current_state(parent_enemy.current_state.next_target[0])
			GlobalEvent.emit_signal("player_hacking_done")

func look_towards(dir:Vector3):
	var rad = atan2(-dir.z,dir.x)
	var q = Quaternion(Vector3.UP, rad)
	var tween = create_tween()
	tween.tween_property(
		mesh_node, 
		"quaternion", 
		q, 
		0.1
	)

# gerakin karakternya
func move(delta):
	if !can_move or !parent_enemy.hacked:
		return
		
	if moving:
		# Animasiin pergerakannya
		#ease_move-=delta
		look_towards(target_position_after_move - parent_enemy.global_position)
		parent_enemy.global_position = lerp(parent_enemy.global_position, target_position_after_move, parent_enemy.movement_speed * 4/5)
		if (parent_enemy.global_position - target_position_after_move).length() < 0.05:
			parent_enemy.global_position = target_position_after_move
			moving = false
	else:
		# Terima input dari user buat arah gerak
		for dir in inputs.keys():
			if dir != "stand" and Input.is_action_pressed(dir):
				last_dir = dir
				step(dir)

#mo jalan ke arah mana
func step(dir):
	if !can_move or !parent_enemy.hacked:
		return
		# Set raycast ke arah gerak pemain
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	GlobalEvent.emit_signal("player_move", dir)
	
	# gak gerak tapi user ada sisa input tengah pergerakan sebelumnya
	if not moving and ease_move > 0:
		# Gerak kalo raycat gk ketemu apapun
		if !ray.is_colliding():
			moving = true
			ease_move=0
			target_position_after_move = parent_enemy.global_position + inputs[forced_dir] * tile_size
	
	# gak gerak
	if not moving:
		if !ray.is_colliding():
			moving = true
			target_position_after_move = parent_enemy.global_position + inputs[dir] * tile_size
