extends CanvasLayer

@export var debug := false

# Fade to black transition
func change_scene(file_path: String, title="", id="", color=""):
	if not debug:
		self.visible=true
		$AnimationPlayer.play("fade_to_black")
		
		await $AnimationPlayer.animation_finished
		
		#reset checkpoint jadi ke awal lg
		GlobalEvent.checkpoint_reached = false
		
		get_tree().change_scene_to_file(file_path)
			
		await get_tree().create_timer(0.5).timeout
		
		$AnimationPlayer.play_backwards("fade_to_black")
		
		await $AnimationPlayer.animation_finished
		
		if title!="" and str(id)!="" and color!="":
			GlobalEvent.emit_signal("level_start", title, id, color)

		await get_tree().create_timer(0.1).timeout
		self.visible=false
	else:
		self.visible=true
		get_tree().change_scene_to_file(file_path)

# Pindah ke level select
func go_back_to_level_select():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	await get_tree().physics_frame
	get_node("/root/main menu").set_up_levelselect()
