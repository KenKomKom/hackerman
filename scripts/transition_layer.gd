extends CanvasLayer

@export var debug := false

func change_scene(file_path: String):
	if not debug:
		self.visible=true
		$AnimationPlayer.play("fade_to_black")
		
		await $AnimationPlayer.animation_finished
		
		get_tree().change_scene_to_file(file_path)
		await get_tree().create_timer(0.5).timeout
		$AnimationPlayer.play_backwards("fade_to_black")
		
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(0.1).timeout
		
		self.visible=false
	else:
		self.visible=true
		get_tree().change_scene_to_file(file_path)
