extends Node

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $UI/TimerLabel
@onready var painting_display: TextureRect = $UI/PaintingDisplay
@onready var drawing_canvas = $SubViewportContainer/SubViewport/Node2D
@onready var original_painting: Image = load("res://assets/duck.png").get_image()

var grid_zones = 8
var time_limit = 30.0  # seconds to draw
var time_remaining = 30.0
var painting_reveal_time = 5.0  # how long to show the painting at start
var game_started = false
var player_image = drawing_canvas.get_canvas_image()
var total_zones = grid_zones * grid_zones
var total_similarity = 0.0
var zone_width = int(player_image.get_width() / grid_zones)
var zone_height = int(player_image.get_height() / grid_zones)

func _ready() -> void:
	# show the painting first
	print(drawing_canvas)
	painting_display.visible = true
	timer_label.text = str(int(painting_reveal_time)) + "s"
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
	painting_reveal_time -= 1.0
	timer_label.text = str(int(time_remaining)) + "s"
	if time_remaining <= 0:
		timer.stop()
		end_game()

func end_game() -> void:
	game_started = false
	drawing_canvas.can_draw = false  # block drawing when time is up
	var score = calculate_score()
	timer_label.text = "Score: " + str(snappedf(score, 0.1)) + "%"

func calculate_score() -> float:

	for zone_x in grid_zones:
		for zone_y in grid_zones:
			var orig_avg = get_zone_average(original_painting, zone_x, zone_y, zone_width, zone_height)
			var player_avg = get_zone_average(player_image, zone_x, zone_y, zone_width, zone_height)
			total_similarity += compare_colors(orig_avg, player_avg)
	
	return (total_similarity / total_zones) * 100.0  # returns 0-100 score

func get_zone_average(image: Image, zone_x: int, zone_y: int, zone_w: int, zone_h: int) -> Color:
	var r = 0.0
	var g = 0.0
	var b = 0.0
	var pixel_count = zone_w * zone_h
	
	for x in zone_w:
		for y in zone_h:
			var px = zone_x * zone_w + x
			var py = zone_y * zone_h + y
			var color = image.get_pixel(px, py)
			r += color.r
			g += color.g
			b += color.b
	
	return Color(r / pixel_count, g / pixel_count, b / pixel_count)

func compare_colors(c1: Color, c2: Color) -> float:
	var diff = abs(c1.r - c2.r) + abs(c1.g - c2.g) + abs(c1.b - c2.b)
	return 1.0 - (diff / 3.0)  # 1.0 = perfect match, 0.0 = completely different
