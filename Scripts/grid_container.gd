extends GridContainer

@onready var drawing_canvas: Node2D = $"../../SubViewportContainer/SubViewport/Node2D"
@onready var paletteclick: AudioStreamPlayer2D = $"../../paletteclick"



func _on_black_pressed() -> void:
	drawing_canvas.brush_color = Color.BLACK
	paletteclick.play()
	

func _on_white_pressed() -> void:
	drawing_canvas.brush_color = Color.WHITE
	paletteclick.play()

func _on_red_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#ff0000")
	paletteclick.play()

func _on_blue_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#3A86FF")
	paletteclick.play()

func _on_brown_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#8b5a2b")
	paletteclick.play()

func _on_yellow_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#fbf236")
	paletteclick.play()


func _on_green_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#6abe30")
	paletteclick.play()


func _on_pink_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#d77bba")
	paletteclick.play()


func _on_gray_pressed() -> void:
	drawing_canvas.brush_color = Color.html("#808080")
	paletteclick.play()
