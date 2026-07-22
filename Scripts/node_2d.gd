extends Node2D

const PIXEL_SIZE := 16
const CANVAS_WIDTH := 32
const CANVAS_HEIGHT := 32

var drawing := false
var brush_color := Color.BLACK

var canvas_image: Image
var canvas_texture: ImageTexture

func _ready() -> void:
	canvas_image = Image.create(CANVAS_WIDTH, CANVAS_HEIGHT, false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color.WHITE)

	canvas_texture = ImageTexture.create_from_image(canvas_image)

func _input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed

			if drawing:
				paint_pixel()

	if event is InputEventMouseMotion and drawing:
		paint_pixel()

func paint_pixel():

	var mouse = get_local_mouse_position()

	var x = int(mouse.x / PIXEL_SIZE)
	var y = int(mouse.y / PIXEL_SIZE)

	if x >= 0 and x < CANVAS_WIDTH and y >= 0 and y < CANVAS_HEIGHT:
		canvas_image.set_pixel(x, y, brush_color)

	canvas_texture.update(canvas_image)
	queue_redraw()

func _draw():

	draw_texture_rect(
		canvas_texture,
		Rect2(
			Vector2.ZERO,
			Vector2(
				CANVAS_WIDTH * PIXEL_SIZE,
				CANVAS_HEIGHT * PIXEL_SIZE
			)
		),
		false
	)

func get_canvas_image() -> Image:
	return canvas_image
