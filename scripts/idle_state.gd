extends enemy_state

class_name enemy_idle_state

var point_A : Vector3
var point_B : Vector3
var current_target : Vector3
var moving : bool = false

#command variables
var current_command: int = 0
var max_command = 0

var target_position_after_move :Vector3
var next_path_position: Vector3
var time_for_timer:float

var is_rotating: bool = false 
var initial_position: Vector3

func _ready():
	initial_position = parent_enemy.global_position
	moving = true
	print("MAX COMMANDS ", max_command)
	max_command = parent_enemy.commands.size()
	print("MAX COMMANDS 2 ", max_command)

func ready_state():
	# Reset moving status and set the target
	var rng = RandomNumberGenerator.new()
	time_for_timer=rng.randf_range(0.2,0.25)
	parent_enemy.redo_target_location_timer.wait_time = time_for_timer
	current_command = 0

func do_something(delta):
	# klo lg dialog, gbs gerak
	if GlobalEvent.stop_for_dialogue:
		return
	
	if is_rotating:
		return
	
	#klo kosong
	if(parent_enemy.commands == null):
		return
<<<<<<< HEAD
	
	
	if(parent_enemy.commands[current_command].type == "move" and max_command != 0):
		#setup variable
		parent_enemy.movement_target = parent_enemy.commands[current_command].targetNode
		parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
		parent_enemy.set_movement_target(parent_enemy.movement_target_position)
		
		#suruh kejar
		#parent_enemy.current_state.next_target[0]
		#print("NEXT COMMAND ", next_target[0])
		parent_enemy.change_current_state(next_target[0])
		
		#Alex
		#if(parent_enemy.global_position.x == parent_enemy.movement_target_position.x and parent_enemy.global_position.z == parent_enemy.movement_target_position.z):
			#current_command = (current_command + 1) % max_command
			#return
		
		#Nev
		if(parent_enemy.global_position - parent_enemy.movement_target_position).length() <= 0.08:
			#print("NEXT COMMAND ", (current_command + 1) % max_command)
			current_command = (current_command + 1) % max_command
			return
		
		#klo dh sampe tujuan, update command ke selanjutnya
		#if parent_enemy.navigation_agent.is_navigation_finished():
			#await get_tree().create_timer(2.0).timeout
=======
	#
	#if(parent_enemy.commands[current_command].type == "move"):
		#
		##setup variable
		#parent_enemy.movement_target = parent_enemy.commands[current_command].targetNode
		#parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
		#parent_enemy.set_movement_target(parent_enemy.movement_target_position)
		#
		##suruh kejar
		##parent_enemy.current_state.next_target[0]
		##print("NEXT COMMAND ", next_target[0])
		#parent_enemy.change_current_state(next_target[0])
		#
		##Alex
		##if(parent_enemy.global_position.x == parent_enemy.movement_target_position.x and parent_enemy.global_position.z == parent_enemy.movement_target_position.z):
			##current_command = (current_command + 1) % max_command
			##return
		#
		##Nev
		#if(parent_enemy.global_position - parent_enemy.movement_target_position).length() <= 0.08:
			##print("NEXT COMMAND ", (current_command + 1) % max_command)
>>>>>>> cd81e18b9ca0dc42b9da9ce531c0aa0092d5a24b
			#current_command = (current_command + 1) % max_command
			#return
		#
		##klo dh sampe tujuan, update command ke selanjutnya
		##if parent_enemy.navigation_agent.is_navigation_finished():
			##await get_tree().create_timer(2.0).timeout
			##current_command = (current_command + 1) % max_command
			##return
		##
		##var next_path_position: Vector3 = parent_enemy.navigation_agent.get_next_path_position()
		##print_debug("next path position: ", next_path_position)
		##print_debug("target_position_after_move: ", target_position_after_move)
		##
		###ke tempatnya
		##if moving:
			##parent_enemy.global_position = lerp(parent_enemy.global_position, target_position_after_move, parent_enemy.movement_speed)
			##if (parent_enemy.global_position-target_position_after_move).length()<0.08:
				##parent_enemy.global_position = target_position_after_move
				##moving = false
			##return
		##
		##var available_dir = next_path_position - parent_enemy.global_position
		##_step_to_available_space(available_dir)
	#
	#elif(parent_enemy.commands[current_command].type == "rotate"):
		#
		#print("CURRENT ROTATION COMMAND ", current_command)
		##rotation & delay
		#is_rotating = true
		#await parent_enemy.look_towards(parent_enemy.commands[current_command].targetNode.global_position)
		#await get_tree().create_timer(2.0).timeout
		#
<<<<<<< HEAD
		#var available_dir = next_path_position - parent_enemy.global_position
		#_step_to_available_space(available_dir)
	
	elif(parent_enemy.commands[current_command].type == "rotate" and max_command != 0):
		
		#rotation & delay
		is_rotating = true
		await parent_enemy.look_towards(parent_enemy.commands[current_command].targetNode.global_position)
		await get_tree().create_timer(3.0).timeout
		
		#klo uda selesai, current_command = (current_command + 1) % max_command
		current_command = (current_command + 1) % max_command
		is_rotating = false
=======
		##klo uda selesai, current_command = (current_command + 1) % max_command
		#current_command = (current_command + 1) % max_command
		#is_rotating = false
>>>>>>> cd81e18b9ca0dc42b9da9ce531c0aa0092d5a24b

func chase_using_raycast():
	#print("FUNCTION CALLED WITH RAYCAST")
	#if (parent_enemy.movement_target_position - parent_enemy.global_position).length() < 4:
	parent_enemy.movement_target = parent_enemy.player
	parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
	parent_enemy.set_movement_target(parent_enemy.movement_target_position)
	parent_enemy.change_current_state(next_target[0])

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
		#print_debug("dir: ",dir)

#func _on_re_target_timer_timeout():
	#parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
	#parent_enemy.set_movement_target(parent_enemy.movement_target_position)
