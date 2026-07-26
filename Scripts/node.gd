extends Node

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $UI/TimerLabel
@onready var painting_display: TextureRect = $UI/PaintingDisplay
@onready var drawing_canvas = $SubViewportContainer/SubViewport/Node2D
@onready var paletteclick: AudioStreamPlayer2D = $paletteclick

var original_painting: Image

var grid_zones = 16
var time_limit = 60
var time_remaining = 60
var painting_reveal_time = 10.0
var painting_reveal_remaining_time = 10.0
var game_started = false
var player_image: Image

var paintings = [
	"res://assets/paintings/duck.png",
	"res://assets/paintings/batman.png",
	"res://assets/paintings/candle.png",
	"res://assets/paintings/cat.png",
	"res://assets/paintings/ET.png",
	"res://assets/paintings/Sword.png",
	"res://assets/paintings/temple.png",
	"res://assets/paintings/yin&yang.png"
	
]

enum GameState { REVEALING, DRAWING }
var current_state = GameState.REVEALING

func _ready() -> void:
	if GameData.accuracy_history.is_empty():
		GameData.reset_run()
		GameData.total_paintings = paintings.size()
		GameData.setup_paintings_queue(paintings) 

	start_reveal_phase()

func start_reveal_phase() -> void:
	current_state = GameState.REVEALING
	drawing_canvas.can_draw = false
	game_started = false
	
	load_random_painting()
	player_image = drawing_canvas.get_canvas_image()
	painting_display.visible = true
	
	painting_reveal_remaining_time = painting_reveal_time
	timer_label.text = str(int(painting_reveal_remaining_time)) + "s"
	
	timer.wait_time = 1.0
	timer.start()

func start_drawing_timer() -> void:
	current_state = GameState.DRAWING
	drawing_canvas.can_draw = true
	game_started = true
	
	time_remaining = time_limit
	timer_label.text = str(int(time_remaining)) + "s"
	
	timer.wait_time = 1.0 
	timer.start()

func _on_timer_timeout() -> void:
	if current_state == GameState.REVEALING:
		painting_reveal_remaining_time -= 1.0
		timer_label.text = str(int(painting_reveal_remaining_time)) + "s"
		
		if painting_reveal_remaining_time <= 0:
			timer.stop()
			painting_display.visible = false
			start_drawing_timer()
			
	elif current_state == GameState.DRAWING:
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
	GameData.add_score(score) 
	
	print("switching scene now")
	Transition.transition_to("res://Scenes/results.tscn")

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
	var path = GameData.pop_next_painting()
	var texture = load(path)
	painting_display.texture = texture
	original_painting = texture.get_image()
	original_painting.resize(grid_zones, grid_zones, Image.INTERPOLATE_LANCZOS)
	
func start_new_round() -> void:
	drawing_canvas.clear_canvas()  
	start_reveal_phase()

func _on_bucket_pressed() -> void:
	drawing_canvas.bucket_mode = true
	paletteclick.play()

func _on_pencil_pressed() -> void:
	drawing_canvas.bucket_mode = false
	paletteclick.play()
