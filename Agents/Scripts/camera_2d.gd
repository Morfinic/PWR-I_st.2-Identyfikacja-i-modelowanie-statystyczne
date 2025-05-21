extends Camera2D

var zoomValue: float = 1
var cameraMove: bool = false

var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false
var _startPosition: Vector2

func _input(event: InputEvent) -> void:
	if !$Wykres.visible and event.is_action("ZoomIn"):
		zoomValue += 0.1
	elif !$Wykres.visible and event.is_action("ZoomOut"):
		zoomValue -= 0.1
	elif event.is_action_pressed("pause"):
		$Wykres.visible = !$Wykres.visible

#dziala jakos i rusza kamere
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		if event.is_pressed():
			_previousPosition = event.position
			_moveCamera = true
			_startPosition = position
		else:
			_moveCamera = false
	elif event is InputEventMouseMotion && _moveCamera:
		get_viewport().set_input_as_handled()
		position += (_previousPosition - event.position) * (1 / zoomValue)
		_previousPosition = event.position
		

func _process(delta: float) -> void:
	zoomValue = clampf(zoomValue, 1, 3)
	zoom = Vector2(zoomValue, zoomValue)
