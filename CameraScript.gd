extends Node3D

var mouse_sensitivity := 0.0075
var zoom_level := 4.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	$CamGymbalX/Camera3D.position.z = lerpf($CamGymbalX/Camera3D.position.z, zoom_level, delta*20)


func _input(event):
	if Input.is_action_pressed("zoom_in"):
		zoom(-0.5)
	elif Input.is_action_pressed("zoom_out"):
		zoom(0.5)
	
	if (Input.is_action_pressed("cam_pan") or (Input.is_action_pressed("cam_rotate") and Input.is_action_pressed("cam_pan_modif"))) and event is InputEventMouseMotion:
		position.x += -event.relative.x * mouse_sensitivity
		position.y += event.relative.y * mouse_sensitivity
		
	elif Input.is_action_pressed("cam_rotate") and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$CamGymbalX.rotate_x(-event.relative.y * mouse_sensitivity)
		$CamGymbalX.rotation.x = clampf($CamGymbalX.rotation.x, -PI/2, PI/2)


func zoom(zoom_amount: float):
	zoom_level = clamp(zoom_level+zoom_amount, 0.5, 64)
