extends GridContainer

@onready var drawing_canvas: Node2D = $"../../SubViewportContainer/SubViewport/Node2D"


func _on_black_pressed() -> void:
	print("black pressed")
	drawing_canvas.brush_color = Color.BLACK

func _on_white_pressed() -> void:
	drawing_canvas.brush_color = Color.WHITE

func _on_red_pressed() -> void:
	drawing_canvas.brush_color = Color.RED

func _on_blue_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#3A86FF")

func _on_brown_pressed() -> void:
	drawing_canvas.brush_color = Color.BROWN

func _on_yellow_pressed() -> void:
	drawing_canvas.brush_color = Color.YELLOW


func _on_green_pressed() -> void:
	drawing_canvas.brush_color = Color.GREEN
