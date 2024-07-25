extends enemy_state

func ready_state():
	var tween = get_tree().create_tween()
	tween.tween_property(
		parent_enemy.mesh_node.get_surface_override_material(0),
		"emission", 
		Color("34240f"),
		1
	)
	#parent_enemy.mesh_node.get_surface_override_material(0).emission = Color("34240f")

func do_something(delta):
	if (parent_enemy.movement_target_position-parent_enemy.global_position).length()<3:
		parent_enemy.change_current_state(next_target[0])
