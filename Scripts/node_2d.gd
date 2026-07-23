extends Node2D

var can_draw = false 
var drawing = false
var brush_color = Color.BLACK
var canvas_size = Vector2(512, 512)
var grid_size = 8  
var cell_size: Vector2
var canvas_image: Image
var canvas_texture: ImageTexture

func _ready() -> void:
	canvas_size = get_parent().size  # gets the SubViewport's size directly
	cell_size = canvas_size / grid_size
	canvas_image = Image.create(int(canvas_size.x), int(canvas_size.y), false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color.WHITE)
	canvas_texture = ImageTexture.create_from_image(canvas_image)

func _input(event: InputEvent) -> void:
	if not can_draw:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			if drawing:
				paint_cell(get_local_mouse_position())
	
	if event is InputEventMouseMotion and drawing:
		paint_cell(get_local_mouse_position())

func paint_cell(mouse_pos: Vector2) -> void:
	# snap to grid
	var cell_x = int(mouse_pos.x / cell_size.x)
	var cell_y = int(mouse_pos.y / cell_size.y)
	
	# clamp so we don't go out of bounds
	cell_x = clamp(cell_x, 0, grid_size - 1)
	cell_y = clamp(cell_y, 0, grid_size - 1)
	
	# fill the entire cell with color
	var pixel_x = int(cell_x * cell_size.x)
	var pixel_y = int(cell_y * cell_size.y)
	
	for x in int(cell_size.x):
		for y in int(cell_size.y):
			canvas_image.set_pixel(pixel_x + x, pixel_y + y, brush_color)
	
	canvas_texture.update(canvas_image)
	queue_redraw()

func _draw() -> void:
	draw_texture(canvas_texture, Vector2.ZERO)

func get_canvas_image() -> Image:
	return canvas_image
