extends Control
@onready var player_display: TextureRect = $Playerpainting
@onready var original_display: TextureRect = $Originalpainting
@onready var accuracy_label: Label = $Accuracylabel
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var next_button: Button = $NextButton

func _ready() -> void:

	var player_texture = ImageTexture.create_from_image(GameData.player_image)
	player_display.texture = player_texture
	
	var original_texture = ImageTexture.create_from_image(GameData.original_image)
	original_display.texture = original_texture
	
	next_button.pressed.connect(_on_next_pressed)
	
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = 100
	
	animate_accuracy()

func animate_accuracy() -> void:
	var target = GameData.accuracy_score
	progress_bar.value = 100
	var tween = create_tween()
	tween.tween_method(_update_accuracy_display, 0.0, target, 1.5)

func _update_accuracy_display(value):
	accuracy_label.text = str(int(value)) + "%"
	progress_bar.value = 100.0 - value
	

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/sub_viewport_container.tscn")
