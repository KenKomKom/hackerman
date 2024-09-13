extends Enemy

class_name EnemyHigh

func interact():
	GlobalEvent.is_hacking = true
	light.visible = false
	GlobalEvent.emit_signal("player_is_hacking", self)
	#print("is hacking = ", GlobalEvent.is_hacking)
	change_current_state(current_state. next_state[1])

func switch_back():
	change_current_state(current_state. next_state[0])
	setup_texture()
	light.visible = false

func setup_texture():
	#siapin texture
	var level: int = get_parent().get_parent().id
	
	var hi_ministry_path:= "res://scenes/guards/material/high ministry.tres"
	var hi_shadow_path:= "res://scenes/guards/material/high shadow.tres"
	
	if(level == 3):
		$"high tier/antivirus high/Skeleton3D/shield body_004".material_override = load(hi_ministry_path)
		$"high tier/antivirus high/Skeleton3D/shield body_005".material_override = load(hi_ministry_path)
		$"high tier/antivirus high/Skeleton3D/shield body_013".material_override = load(hi_ministry_path)
	elif(level == 4):
		$"high tier/antivirus high/Skeleton3D/shield body_004".material_override = load(hi_shadow_path)
		$"high tier/antivirus high/Skeleton3D/shield body_005".material_override = load(hi_shadow_path)
		$"high tier/antivirus high/Skeleton3D/shield body_013".material_override = load(hi_shadow_path)

func setup_texture_hacked():
	var hacked_path:= "res://scenes/guards/material/high hacked.tres"
	$"high tier/antivirus high/Skeleton3D/shield body_004".material_override = load(hacked_path)
	$"high tier/antivirus high/Skeleton3D/shield body_005".material_override = load(hacked_path)
	$"high tier/antivirus high/Skeleton3D/shield body_013".material_override = load(hacked_path)
