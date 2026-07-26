extends Node

@onready var buttonpress: AudioStreamPlayer2D = $Buttons/buttonpress



func _on_start_pressed() -> void:
	Transition.transition_to("res://Scenes/sub_viewport_container.tscn")
	buttonpress.play()


func _on_exit_pressed() -> void:
	get_tree().quit() 
	buttonpress.play()
