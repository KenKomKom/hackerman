extends enemy_state

class_name enemy_chasing_state

var moving = false
var target_position_after_move :Vector3
var time_for_timer:float

func ready_state():
	# Tiap robot dibedain waktu buat update posisi player biar gk bengkak komputasi
	var rng = RandomNumberGenerator.new()
	time_for_timer = rng.randf_range(0.2,0.25)
	parent_enemy.redo_target_location_timer.wait_time = time_for_timer
	
	#set target jadi player
	parent_enemy.movement_target = parent_enemy.player

func do_something(delta):
	# klo lg dialog, gbs gerak
	if GlobalEvent.stop_for_dialogue:
		return
	
	GameManager.player_chased = true
	
	#Change state
	if (parent_enemy.movement_target_position-parent_enemy.global_position).length()>4 and parent_enemy.movement_target is Player :
		parent_enemy.change_current_state(next_target[0])
		GameManager.player_chased = false
	
	# Udh sampe di posisi, tunggu update posisi
	if parent_enemy.navigation_agent.is_navigation_finished():
		#print("MOVEMENT FINISHED FOR COMMAND NUM ", parent_enemy.get_node("states/idle").current_command)
		#parent_enemy.current_state.next_target[0]
		parent_enemy.change_current_state(next_target[0])
		return

	#var current_agent_position: Vector3 = parent_enemy.global_position
	var next_path_position: Vector3 = parent_enemy.navigation_agent.get_next_path_position()
	#print_debug("(chasing) next path target_position_after_move: ", target_position_after_move)
	#print_debug("(chasing) next path position: ", next_path_position)
	
	# lakuin animasi
	if moving:
		parent_enemy.global_position = lerp(parent_enemy.global_position,target_position_after_move,parent_enemy.movement_speed)
		#print("AFTER LERP CURRENT: ", parent_enemy.global_position, " TARGET : ", target_position_after_move)
		if (parent_enemy.global_position-target_position_after_move).length()<0.08:
			parent_enemy.global_position=target_position_after_move
			#print("LOCATION REACHED")
			moving = false
		return
	var available_dir = next_path_position-parent_enemy.global_position
	
	_step_to_available_space(available_dir)

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
		#print_debug(parent_enemy.global_position)
		target_position_after_move = parent_enemy.global_position + dir * parent_enemy.tile_size
		#print_debug(dir)

func _on_re_target_timer_timeout():
	parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
	parent_enemy.set_movement_target(parent_enemy.movement_target_position)
