extends enemy_state

class_name enemy_chasing_state

var moving = false
var target_position_after_move: Vector3
var time_for_timer: float

func ready_state():
	# Tiap robot dibedain waktu buat update posisi player biar gk bengkak komputasi
	print_debug("setup chasing state")
	var rng = RandomNumberGenerator.new()
	time_for_timer = rng.randf_range(0.2,0.25)
	parent_enemy.redo_target_location_timer.wait_time = time_for_timer
	
	#set target jadi player
	parent_enemy.movement_target = parent_enemy.player

func do_something(delta):
	
	# klo lg chasing baru bisa masuk
	if(parent_enemy.current_state.name != "chasing"):
		print_debug(parent_enemy.current_state.name)
		return
	
	# klo lg dialog, gbs gerak
	if GlobalEvent.stop_for_dialogue or parent_enemy.hacked:
		return
	
	GameManager.player_chased = true
	
	#change state klo uda kejauhan dri player
	if (parent_enemy.movement_target_position-parent_enemy.global_position).length() > 4 and parent_enemy.movement_target is Player :
		parent_enemy.change_current_state(next_state[0])
		GameManager.player_chased = false
	
	#kill player klo uda nempel 1 tile
	if (parent_enemy.global_position - parent_enemy.player.global_position).length() <= 1.1 and !parent_enemy.hacked:
		kill_player()
		var level = parent_enemy.get_parent().get_parent()
		GameManager.player_chased = false
		
		#player death SFX
		#randomize pitch
		await get_tree().create_timer(0.5).timeout
		#var rng = RandomNumberGenerator.new()
		#level.audio_manager.hacker_shout.pitch_scale = rng.randf_range(1.4, 1.6)
		#level.audio_manager.hacker_shout.play(0.0)
		
		#robot pull in SFX
		await get_tree().create_timer(1).timeout
		level.audio_manager.robot_kill.play(0.0)
		return
	
	#var current_agent_position: Vector3 = parent_enemy.global_position
	var next_path_position: Vector3 = parent_enemy.navigation_agent.get_next_path_position()
	
	# lakuin animasi
	if moving:
		parent_enemy.global_position = lerp(parent_enemy.global_position,target_position_after_move,parent_enemy.movement_speed)
		if (parent_enemy.global_position-target_position_after_move).length() < 0.08:
			parent_enemy.global_position=target_position_after_move
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

func _on_re_target_timer_timeout():
	parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
	parent_enemy.set_movement_target(parent_enemy.movement_target_position)

func kill_player():
	if(parent_enemy.hacked):
		return
	
	#suruh player & enemy berhenti
	var player = parent_enemy.player
	player.is_dialogue("")
	
	#look towards each other
	await get_tree().create_timer(0.1).timeout
	player.look_towards(parent_enemy.global_position - player.global_position)
	parent_enemy.look_towards(player.global_position - parent_enemy.global_position)
	#get_tree().paused = true
	
	#play animation
	player.update_animation("low_kill")
	parent_enemy.anim_player.play("antivirus low - kill")
	
	#tunggu dia play animation dulu
	await parent_enemy.anim_player.animation_finished
	
	#bs jalan lg, tp abistu lgs kill
	GlobalEvent.emit_signal("player_is_dead")
	GlobalEvent.stop_for_dialogue = false
