extends Node

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $UI/TimerLabel
@onready var painting_display: TextureRect = $UI/PaintingDisplay
@onready var drawing_canvas = $SubViewportContainer/SubViewport/Node2D

var original_painting: Image

var grid_zones = 16
var time_limit = 30.0
var time_remaining = 30.0
var painting_reveal_time = 5.0
var game_started = false
var player_image: Image

var paintings = [
	"res://assets/paintings/candle.png",
	"res://assets/paintings/duck.png",
	"res://assets/paintings/ET.png",
	"res://assets/paintings/Sword.png",
	"res://assets/paintings/temple.png"
	
]



func _ready() -> void:
	load_random_painting()
	player_image = drawing_canvas.get_canvas_image()
	painting_display.visible = true
	timer_label.text = str(int(painting_reveal_time)) + "s"
	await get_tree().create_timer(painting_reveal_time).timeout
	painting_display.visible = false
	start_drawing_timer()

func _input(event: InputEvent) -> void:
	if !can_draw:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var pos = get_local_mouse_position()
			if bucket_mode:
				bucket_fill(pos)
			else:
				drawing = true
				paint_pixel(pos)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		drawing = false
	if event is InputEventMouseMotion and drawing and !bucket_mode:
		paint_pixel(get_local_mouse_position())

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
	drawing_canvas.can_draw = false
	var score = calculate_score()
	timer_label.text = "Score: " + str(snappedf(score, 0.1)) + "%"
	
	await get_tree().create_timer(3.0).timeout  # pause to show score
	start_new_round()

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
	var path = paintings[randi() % paintings.size()]
	var texture = load(path)
	painting_display.texture = texture
	original_painting = texture.get_image()
	original_painting.resize(grid_zones, grid_zones, Image.INTERPOLATE_LANCZOS)
	
func start_new_round() -> void:
	drawing_canvas.clear_canvas()  # you'll need to add this function, see below
	load_random_painting()
	painting_display.visible = true
	timer_label.text = str(int(painting_reveal_time)) + "s"
	await get_tree().create_timer(painting_reveal_time).timeout
	painting_display.visible = false
	start_drawing_timer()

func bucket_fill(mouse_pos: Vector2) -> void:
	var start_x = int(mouse_pos.x / cell_size.x)
	var start_y = int(mouse_pos.y / cell_size.y)
	start_x = clamp(start_x, 0, GRID_SIZE - 1)
	start_y = clamp(start_y, 0, GRID_SIZE - 1)
	
	var target_color = canvas_image.get_pixel(start_x, start_y)
	if target_color == brush_color:
		return  # already the same color, nothing to do
	
	var stack = [Vector2i(start_x, start_y)]
	var visited = {}
	
	while stack.size() > 0:
		var current = stack.pop_back()
		var cx = current.x
		var cy = current.y
		
		if cx < 0 or cx >= GRID_SIZE or cy < 0 or cy >= GRID_SIZE:
			continue
		if visited.has(current):
			continue
		if canvas_image.get_pixel(cx, cy) != target_color:
			continue
		
		visited[current] = true
		canvas_image.set_pixel(cx, cy, brush_color)
		
		stack.append(Vector2i(cx + 1, cy))
		stack.append(Vector2i(cx - 1, cy))
		stack.append(Vector2i(cx, cy + 1))
		stack.append(Vector2i(cx, cy - 1))
	
	canvas_texture.update(canvas_image)
	queue_redraw()
