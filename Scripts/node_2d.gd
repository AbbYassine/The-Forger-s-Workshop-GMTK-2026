extends Node2D

var can_draw = false
var drawing = false
var brush_color = Color.BLACK
var undo_stack: Array[Image] = []
var max_undo_steps = 20

const GRID_SIZE = 16
var DISPLAY_SIZE = Vector2(450, 450)

var cell_size: Vector2
var bucket_mode = false
var canvas_image: Image
var canvas_texture: ImageTexture

func _ready():
	cell_size = DISPLAY_SIZE / GRID_SIZE

	canvas_image = Image.create(GRID_SIZE, GRID_SIZE, false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color.GRAY)

	canvas_texture = ImageTexture.create_from_image(canvas_image)

func _input(event: InputEvent) -> void:
	if !can_draw:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var pos = get_local_mouse_position()
			save_undo_state()  # ADD THIS — save before the change
			if bucket_mode:
				bucket_fill(pos)
			else:
				drawing = true
				paint_pixel(pos)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		drawing = false
	if event is InputEventMouseMotion and drawing and !bucket_mode:
		paint_pixel(get_local_mouse_position())
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_Z and event.ctrl_pressed:
		undo()

func paint_pixel(mouse_pos: Vector2):

	var x = int(mouse_pos.x / cell_size.x)
	var y = int(mouse_pos.y / cell_size.y)

	x = clamp(x, 0, GRID_SIZE - 1)
	y = clamp(y, 0, GRID_SIZE - 1)

	canvas_image.set_pixel(x, y, brush_color)

	canvas_texture.update(canvas_image)
	queue_redraw()

func _draw():

	draw_texture_rect(
		canvas_texture,
		Rect2(Vector2.ZERO, DISPLAY_SIZE),
		false
	)

func get_canvas_image() -> Image:
	return canvas_image
	
func clear_canvas() -> void:
	canvas_image.fill(Color.GRAY)  
	canvas_texture.update(canvas_image)
	queue_redraw()

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

func save_undo_state() -> void:
	var snapshot = canvas_image.duplicate()
	undo_stack.append(snapshot)
	if undo_stack.size() > max_undo_steps:
		undo_stack.pop_front()

func undo() -> void:
	if undo_stack.size() > 0:
		canvas_image = undo_stack.pop_back()
		canvas_texture.update(canvas_image)
		queue_redraw()
