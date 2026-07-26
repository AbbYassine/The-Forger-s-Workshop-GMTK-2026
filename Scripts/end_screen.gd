extends Control

@onready var result_label: Label = $ResultLabel
@onready var average_label: Label = $AverageLabel
@onready var retry_button: Button = $RetryButton
@onready var buttonpress: AudioStreamPlayer2D = $buttonpress

const WIN_THRESHOLD = 70.0

func _ready() -> void:
	var average = GameData.get_average_accuracy()
	
	if average >= WIN_THRESHOLD:
		result_label.text = "Congrats ! After all that hard Work the museum did't notice that you changed those artwork 
		 your talent knows no bounds"
	else:
		result_label.text = "After all that hard work you got caught...... 
		it seems you need to work on your paintings skill (GIT GUD)"
	if retry_button.pressed.connect(_on_retry_pressed):
		GameData.reset_run()

func _on_retry_pressed() -> void:
	GameData.reset_run()
	Transition.transition_to("res://Scenes/sub_viewport_container.tscn")
	buttonpress.play()


func _on_exit_button_pressed() -> void:
	buttonpress.play()
	get_tree().quit()


func _on_retry_button_pressed() -> void:
	pass # Replace with function body.
