extends CanvasLayer

@export var debug := false

# Fade to black transition
func change_scene(file_path: String):
	if not debug:
		self.visible = true
		
		$AnimationPlayer.play("fade_to_black")
		await $AnimationPlayer.animation_finished
		
		#reset ke awal semua
		reset_level()
		
		var result = get_tree().change_scene_to_file(file_path)
		if result != OK:
			print("Error changing scene to:", file_path)
			return
		
		await get_tree().create_timer(0.5).timeout
		
		$AnimationPlayer.play_backwards("fade_to_black")
		await $AnimationPlayer.animation_finished
		
		GlobalEvent.emit_signal("level_start")

		await get_tree().create_timer(0.1).timeout
		self.visible = false
	else:
		self.visible = true
		get_tree().change_scene_to_file(file_path)

# Pindah ke level select
func go_back_to_level_select():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	await get_tree().physics_frame
	get_node("/root/main menu").set_up_levelselect()

func reset_level():
	GlobalEvent.checkpoint_reached = false
	GlobalEvent.database_downloaded = false
	GlobalEvent.is_hacking = false
	GlobalEvent.stop_for_dialogue = false
	GlobalEvent.banner_activated = false
