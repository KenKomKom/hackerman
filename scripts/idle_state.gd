extends enemy_state

class_name enemy_idle_state

#command variables
var current_command: int = 0
var max_command: int = 0

var moving : bool = false
var target_position_after_move: Vector3
var time_for_timer: float

var is_rotating: bool = false

func _ready():
	#moving = true
	current_command = 0
	max_command = parent_enemy.commands.size()

func ready_state():
	print_debug("enter idle state")
	var rng = RandomNumberGenerator.new()
	time_for_timer = rng.randf_range(0.2,0.25)
	parent_enemy.redo_target_location_timer.wait_time = time_for_timer
	
	#find the next move command, set jd next target
	while(parent_enemy.commands[current_command].type != "move"):
		#print_debug(current_command, " ", parent_enemy.commands[current_command].type)
		current_command = (current_command + 1) % max_command
	parent_enemy.movement_target = parent_enemy.commands[current_command].target_node
	#print_debug(parent_enemy.movement_target)
	
	#reset semuanya
	is_rotating = false

func do_something(delta):
	# klo lg dialog, gbs gerak
	if(parent_enemy.current_state.name != "idle"):
		print_debug(parent_enemy.current_state.name)
		return
	
	if GlobalEvent.stop_for_dialogue or parent_enemy.hacked:
		return
	
	#klo lg rotating
	if is_rotating:
		return
	
	#klo kosong
	if(max_command == 0):
		return
	
	#TODO: MOVE TO TARGET NODE
	#TODO: masi ngebug dia bs terbang ke tpt yg sama (hrs cek navigationnya)
	if(parent_enemy.commands[current_command].type == "move"):
		#setup variable klo dh selesai moving
		
		#if !moving:
			#parent_enemy.movement_target = parent_enemy.commands[current_command].target_node
			#parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
			#parent_enemy.set_movement_target(parent_enemy.movement_target_position)
		
		#base case: klo udah sampe tujuan
		if parent_enemy.navigation_agent.is_navigation_finished():
			current_command = (current_command + 1) % max_command
			return
		
		if(parent_enemy.global_position - parent_enemy.movement_target_position).length() <= 0.005:
			current_command = (current_command + 1) % max_command
			return
		
		var next_path_position: Vector3 = parent_enemy.navigation_agent.get_next_path_position()
		#print_debug(parent_enemy.global_position, " ", next_path_position)
		
		# lakuin animasi
		if moving:
			parent_enemy.global_position = lerp(parent_enemy.global_position,target_position_after_move,parent_enemy.movement_speed)
			if (parent_enemy.global_position - target_position_after_move).length() < 0.08:
				parent_enemy.global_position = target_position_after_move
				moving = false
			return
		var available_dir = next_path_position - parent_enemy.global_position
		
		_step_to_available_space(available_dir)
	
	#ROTATE TARGET
	elif(parent_enemy.commands[current_command].type == "rotate"):
		
		#start rotation & delay
		is_rotating = true
		
		#rotate sesuai arah yg di assign
		var dir = parent_enemy.commands[current_command].rotate_dir
		if(dir == "left"):
			await parent_enemy.look_towards(Vector3(0,0,1))
		if(dir == "right"):
			await parent_enemy.look_towards(Vector3(0,0,-1))
		if(dir == "up"):
			await parent_enemy.look_towards(Vector3(-1,0,0))
		if(dir == "down"):
			await parent_enemy.look_towards(Vector3(1,0,0))
		
		#ini cuma delay abis muter, klo mau bisa adjust timenya / apus 
		await get_tree().create_timer(3.0).timeout
		
		#klo uda selesai, lanjut ke command selanjutnya
		current_command = (current_command + 1) % max_command
		is_rotating = false

func chase_using_raycast():
	parent_enemy.movement_target = parent_enemy.player
	parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
	parent_enemy.set_movement_target(parent_enemy.movement_target_position)
	parent_enemy.change_current_state(next_state[0])

# Ini legit gk usah dipikirin
func _step_to_available_space(available_dir):
	
	var dir = Vector3.ZERO
	# pilih arah yg gk terhalang kalo dua duanya bisa
	if (available_dir).z!=0 and (available_dir).x!=0:
		if abs((available_dir).z)>abs((available_dir).x):
			if (available_dir).z<0:
				dir = Vector3(0,0,-1)
			elif (available_dir).z>0:
				dir = Vector3(0,0,1)
		else:
			if (available_dir).x<0:
				dir = Vector3(-1,0,0)
			elif (available_dir).x>0:
				dir = Vector3(1,0,0)
	# antara x atau z terhalang
	else:
		dir = Vector3(sign(available_dir.x),0,0) if available_dir.x!=0 else Vector3(0,0,sign(available_dir.z))
		
	# gak gerak
	if not moving:
		parent_enemy.ray.target_position = dir * parent_enemy.tile_size
		await get_tree().create_timer(0.01).timeout # JAMIN CONCURRENCY
		parent_enemy.ray.force_raycast_update()
		if parent_enemy.ray.is_colliding():
			if abs(dir)==Vector3(1,0,0):
				if (available_dir).z<0:
					dir = Vector3(0,0,-1)
				elif (available_dir).z>0:
					dir = Vector3(0,0,1)
				else:
					dir = Vector3(0,0,0)
			else:
				if (available_dir).x<0:
					dir = Vector3(-1,0,0)
				elif (available_dir).x>0:
					dir = Vector3(1,0,0)
				else:
					dir = Vector3(0,0,0)
			parent_enemy.ray.target_position = dir * parent_enemy.tile_size
			await get_tree().create_timer(0.01).timeout  # JAMIN CONCURRENCY
			parent_enemy.ray.force_raycast_update()
			if parent_enemy.ray.is_colliding():
				dir = Vector3(0,0,0)
		moving = true
		parent_enemy.look_towards(dir)
		target_position_after_move = parent_enemy.global_position + dir * parent_enemy.tile_size
