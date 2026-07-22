extends Node2D

var drawing = false
var brush_size = 5
var brush_color = Color.BLACK
var last_position = Vector2.ZERO
var canvas_image: Image
var canvas_texture: ImageTexture
var canvas_size = Vector2(512, 512)

func _ready() -> void:
	canvas_image = Image.create(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color.WHITE)
	canvas_texture = ImageTexture.create_from_image(canvas_image)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			if drawing:
				last_position = get_local_mouse_position()
	
	if event is InputEventMouseMotion and drawing:
		var current_position = get_local_mouse_position()
		draw_stroke(last_position, current_position)
		last_position = current_position

func draw_stroke(from: Vector2, to: Vector2) -> void:
	var distance = from.distance_to(to)
	var steps = max(1, int(distance))
	for i in steps:
		var point = from.lerp(to, float(i) / steps)
		draw_circle_on_image(point)
	canvas_texture.update(canvas_image)
	queue_redraw()

func draw_circle_on_image(pos: Vector2) -> void:
	for x in range(-brush_size, brush_size + 1):
		for y in range(-brush_size, brush_size + 1):
			if x * x + y * y <= brush_size * brush_size:
				var px = int(pos.x) + x
				var py = int(pos.y) + y
				if px >= 0 and px < canvas_size.x and py >= 0 and py < canvas_size.y:
					canvas_image.set_pixel(px, py, brush_color)

func _draw() -> void:
	draw_texture(canvas_texture, Vector2.ZERO)

func get_canvas_image() -> Image:
	return canvas_image
