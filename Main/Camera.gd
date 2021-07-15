extends Camera2D

var _previousPosition = Vector2(0, 0);
var _dragging = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			var new_zoom = min(2, zoom.x + 0.1)
			zoom = Vector2(new_zoom,new_zoom)
		elif event.button_index == BUTTON_WHEEL_UP:
			var new_zoom = max(0.1, zoom.x - 0.1)
			zoom = Vector2(new_zoom,new_zoom)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			if event.is_pressed():
				_previousPosition = event.position;
				_dragging = true
			else:
				_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		get_tree().set_input_as_handled();
		position += (_previousPosition - event.position) * zoom;
		_previousPosition = event.position;
