extends Node

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $UI/TimerLabel
@onready var painting_display: TextureRect = $UI/PaintingDisplay
@onready var drawing_canvas = $SubViewportContainer/SubViewport/Node2D

var original_painting: Image

var grid_zones = 16
var time_limit = 3
var time_remaining = 3
var painting_reveal_time = 5.0
var game_started = false
var player_image: Image

var paintings = [
	"res://assets/paintings/candle.png",
	"res://assets/paintings/duck.png",
	"res://assets/paintings/temple.png",
	"res://assets/paintings/batman.png",
	"res://assets/paintings/ET.png",
	"res://assets/paintings/Sword.png",
	"res://assets/paintings/candle.png",
	"res://assets/paintings/cat.png",
	"res://assets/paintings/yin&yang.png"
	
]

var paintings_queue: Array = []


func _ready() -> void:
	paintings_queue = paintings.duplicate()
	paintings_queue.shuffle()
	load_random_painting()
	player_image = drawing_canvas.get_canvas_image()
	painting_display.visible = true
	timer_label.text = str(int(painting_reveal_time)) + "s"
	await get_tree().create_timer(painting_reveal_time).timeout
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
	print("end_game called, score: ", calculate_score())
	game_started = false
	drawing_canvas.can_draw = false
	var score = calculate_score()
	
	GameData.player_image = drawing_canvas.get_canvas_image()
	GameData.original_image = original_painting
	GameData.accuracy_score = score
	
	print("switching scene now")
	get_tree().change_scene_to_file("res://Scenes/results.tscn")

func calculate_score() -> float:
	player_image = drawing_canvas.get_canvas_image()
	var matches := 0
	var total := 0
	for x in range(grid_zones):
		for y in range(grid_zones):
			total += 1
			if player_image.get_pixel(x, y) == original_painting.get_pixel(x, y):
				matches += 1
	return float(matches) / float(total) * 100.0
	
func load_random_painting() -> void:
	if paintings_queue.size() == 0:
		paintings_queue = paintings.duplicate()
		paintings_queue.shuffle()
	
	var path = paintings_queue.pop_back()
	var texture = load(path)
	painting_display.texture = texture
	original_painting = texture.get_image()
	original_painting.resize(grid_zones, grid_zones, Image.INTERPOLATE_LANCZOS)
	
func start_new_round() -> void:
	drawing_canvas.clear_canvas()  
	load_random_painting()
	painting_display.visible = true
	timer_label.text = str(int(painting_reveal_time)) + "s"
	await get_tree().create_timer(painting_reveal_time).timeout
	painting_display.visible = false
	start_drawing_timer()


func _on_bucket_pressed() -> void:
	drawing_canvas.bucket_mode = true


func _on_pencil_pressed() -> void:
	drawing_canvas.bucket_mode = false
