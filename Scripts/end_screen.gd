extends Control

@onready var result_label: Label = $ResultLabel
@onready var average_label: Label = $AverageLabel
@onready var retry_button: Button = $RetryButton

const WIN_THRESHOLD = 60.0

func _ready() -> void:
	var average = GameData.get_average_accuracy()
	average_label.text = "Average Accuracy: " + str(snappedf(average, 0.1)) + "%"
	
	if average >= WIN_THRESHOLD:
		result_label.text = "You Win!"
	else:
		result_label.text = "You Lose!"
	if retry_button.pressed.connect(_on_retry_pressed):
		GameData.reset_run()

func _on_retry_pressed() -> void:
	GameData.reset_run()
	get_tree().change_scene_to_file("res://Scenes/sub_viewport_container.tscn")
