extends Node

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $UI/TimerLabel
@onready var painting_display: TextureRect = $UI/PaintingDisplay
@onready var drawing_canvas = $SubViewportContainer/SubViewport/Node2D

var time_limit = 30.0  # seconds to draw
var time_remaining = 30.0
var painting_reveal_time = 5.0  # how long to show the painting at start
var game_started = false

func _ready() -> void:
	# show the painting first
	painting_display.visible = true
	await get_tree().create_timer(painting_reveal_time).timeout
	# hide painting and start the drawing timer
	painting_display.visible = false
	start_drawing_timer()

func start_drawing_timer() -> void:
	drawing_canvas.can_draw = true
	game_started = true
	time_remaining = time_limit
	timer_label.text = str(int(time_remaining)) + "s"
	timer.wait_time = 1.0  # ticks every second
	timer.start()

func _on_timer_timeout() -> void:
	time_remaining -= 1.0
	timer_label.text = str(int(time_remaining)) + "s"
	if time_remaining <= 0:
		timer.stop()
		end_game()

func end_game() -> void:
	game_started = false
	# calculate score here later
	timer_label.text = "Time's up!"
