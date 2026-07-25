extends CanvasLayer

func transition_to(path: String) -> void:
	var color_rect = get_node_or_null("ColorRect")
	var animation_player = get_node_or_null("AnimationPlayer")
	
	# Fallback safety check so the game never crashes or freezes
	if not color_rect or not animation_player:
		print("Warning: Transition nodes not found, changing scene instantly.")
		get_tree().change_scene_to_file(path)
		return
	
	color_rect.visible = true
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(path)
	
	animation_player.play("fade_to_normal")
	await animation_player.animation_finished
	color_rect.visible = false
