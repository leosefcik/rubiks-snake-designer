extends Spatial

var mouse_sensitivity := 0.006
var zoom_level := 10.0
signal cameraMovementDetected()
var block_cam := false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	$CamGimbalX/Camera3D.translation.z = lerp($CamGimbalX/Camera3D.translation.z, zoom_level, Tools.damp(20, delta))


func _unhandled_input(event):
	if Input.is_action_pressed("zoom_in"):
		zoom(-0.5)
	elif Input.is_action_pressed("zoom_out"):
		zoom(0.5)
	
	if Input.is_action_just_released("cam_pan") or Input.is_action_just_released("cam_rotate"):
		block_cam = false
	if block_cam:
		return
	
	if ((Input.is_action_pressed("cam_pan") or (Input.is_action_pressed("cam_rotate") and Input.is_action_pressed("cam_pan_modif"))) and event is InputEventMouseMotion):
		pan(event.relative)
	elif event is InputEventPanGesture:
		pan(event.delta)
	
	elif (Input.is_action_pressed("cam_rotate") and event is InputEventMouseMotion) or event is InputEventScreenDrag:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$CamGimbalX.rotate_x(-event.relative.y * mouse_sensitivity)
		$CamGimbalX.rotation.x = clamp($CamGimbalX.rotation.x, -PI/2, PI/2)
		emit_signal("cameraMovementDetected")


func pan(relative: Vector2):
	var cam_basis = $CamGimbalX/Camera3D.global_transform.basis
	var right = cam_basis.x
	var up = cam_basis.y
	
	var movement = -right * relative.x * mouse_sensitivity * zoom_level * 0.2
	movement -= -up * relative.y *  mouse_sensitivity * zoom_level * 0.2
	
	global_translate(movement)
	emit_signal("cameraMovementDetected")

func zoom(zoom_amount: float):
	if zoom_level > 20: zoom_level = clamp(zoom_level+zoom_amount*4, 0.5, 128)
	else: zoom_level = clamp(zoom_level+zoom_amount, 0.5, 128)
	emit_signal("cameraMovementDetected")
