extends Node2D

var can_draw = false
var drawing = false
var brush_color = Color.BLACK

const GRID_SIZE = 16
var DISPLAY_SIZE = Vector2(450, 450)

var cell_size: Vector2

var canvas_image: Image
var canvas_texture: ImageTexture

func _ready():
	cell_size = DISPLAY_SIZE / GRID_SIZE

	canvas_image = Image.create(GRID_SIZE, GRID_SIZE, false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color.GRAY)

	canvas_texture = ImageTexture.create_from_image(canvas_image)

func _input(event):

	if !can_draw:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed

			if drawing:
				paint_pixel(get_local_mouse_position())

	if event is InputEventMouseMotion and drawing:
		paint_pixel(get_local_mouse_position())

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
