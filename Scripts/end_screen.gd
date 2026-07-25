extends Control

@onready var result_label: Label = $ResultLabel
@onready var average_label: Label = $AverageLabel
@onready var retry_button: Button = $RetryButton

const WIN_THRESHOLD = 60.0

func _ready() -> void:
	var average = GameData.get_average_accuracy()
	
	if average >= WIN_THRESHOLD:
		result_label.text = "Congrats ! After all that hard Work the museum did't notice that you changed those artwork , your talent knows no bounds"
	else:
		result_label.text = "After all that hard work you got caught...... it seems you need to work on your paintings skill"
	if retry_button.pressed.connect(_on_retry_pressed):
		GameData.reset_run()

func _on_retry_pressed() -> void:
	GameData.reset_run()
	get_tree().change_scene_to_file("res://Scenes/sub_viewport_container.tscn")
