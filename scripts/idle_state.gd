extends enemy_state

class_name enemy_idle_state

func ready_state():
	#var tween = get_tree().create_tween()
	#tween.tween_property(
		#parent_enemy.mesh_node.get_surface_override_material(0),
		#"emission", 
		#Color("34240f"),
		#1
	#)
	pass

func do_something(delta):
	if (parent_enemy.movement_target_position-parent_enemy.global_position).length()<3:
		parent_enemy.change_current_state(next_target[0])
		
		#Tries to warn other hive if this enemy is connected to the central
		var central = parent_enemy.central
		if(central):
			central.send_alert_signal()
