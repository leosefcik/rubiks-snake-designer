extends Spatial

var mouse_sensitivity := 0.0075
var zoom_level := 8.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	$CamGimbalX/Camera3D.translation.z = lerp($CamGimbalX/Camera3D.translation.z, zoom_level, delta*20)


func _unhandled_input(event):
	if Input.is_action_pressed("zoom_in"):
		zoom(-0.5)
	elif Input.is_action_pressed("zoom_out"):
		zoom(0.5)
	
	if (Input.is_action_pressed("cam_pan") or (Input.is_action_pressed("cam_rotate") and Input.is_action_pressed("cam_pan_modif"))) and event is InputEventMouseMotion:
		
		var cam_basis = $CamGimbalX/Camera3D.global_transform.basis
		var right = cam_basis.x
		var up = cam_basis.y
		
		var movement = -right * event.relative.x * mouse_sensitivity * zoom_level * 0.20
		movement -= -up * event.relative.y *  mouse_sensitivity * zoom_level * 0.20
		
		global_translate(movement)
		
	elif Input.is_action_pressed("cam_rotate") and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$CamGimbalX.rotate_x(-event.relative.y * mouse_sensitivity)
		$CamGimbalX.rotation.x = clamp($CamGimbalX.rotation.x, -PI/2, PI/2)


func zoom(zoom_amount: float):
	zoom_level = clamp(zoom_level+zoom_amount, 0.5, 64)
