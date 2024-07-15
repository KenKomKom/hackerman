extends enemy_state

var moving=false
var target_position_after_move :Vector3

func ready_state():
	var tween = get_tree().create_tween()
	tween.tween_property(
		parent_enemy.mesh_node.get_surface_override_material(0),
		"emission", 
		Color("51000a"),
		1
	)
	parent_enemy.mesh_node.get_surface_override_material(0).emission = Color("51000a")

func do_something(delta):
	GameManager.player_chased=true
	
	#Change state
	if (parent_enemy.movement_target_position-parent_enemy.global_position).length()>4:
		parent_enemy.change_current_state(next_target[0])
		GameManager.player_chased=false
	
	if parent_enemy.navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = parent_enemy.global_position
	var next_path_position: Vector3 = parent_enemy.navigation_agent.get_next_path_position()
	
	if moving:
		parent_enemy.global_position = lerp(parent_enemy.global_position,target_position_after_move,parent_enemy.movement_speed)
		if (parent_enemy.global_position-target_position_after_move).length()<0.08:
			parent_enemy.global_position=target_position_after_move
			moving=false
		return
	var available_dir = next_path_position-parent_enemy.global_position
	var dir = Vector3.ZERO
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
	else:
		dir = Vector3(sign(available_dir.x),0,0) if available_dir.x!=0 else Vector3(0,0,sign(available_dir.z))
	step(dir,available_dir)

func step(dir,available_dir):
	# gak gerak
	if not moving:
		parent_enemy.ray.target_position = dir * parent_enemy.tile_size
		parent_enemy.ray.force_raycast_update()
		if parent_enemy.ray.is_colliding():
			if abs(dir)==Vector3(1,0,0):
				if (available_dir).z<0:
					dir = Vector3(0,0,-1)
				elif (available_dir).z>0:
					dir = Vector3(0,0,1)
			else:
				if (available_dir).x<0:
					dir = Vector3(-1,0,0)
				elif (available_dir).x>0:
					dir = Vector3(1,0,0)
		moving = true
		parent_enemy.look_towards(dir)
		target_position_after_move = parent_enemy.global_position + dir * parent_enemy.tile_size

func _on_re_target_timer_timeout():
	parent_enemy.movement_target_position = parent_enemy.movement_target.global_position
	parent_enemy.set_movement_target(parent_enemy.movement_target_position)
