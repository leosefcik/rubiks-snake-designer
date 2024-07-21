extends Node3D

var index: int

signal prismClicked

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_collision_l_mouse_entered():
	$SelectionL.show()

func _on_collision_r_mouse_entered():
	$SelectionR.show()

func _on_collision_l_mouse_exited():
	$SelectionL.hide()

func _on_collision_r_mouse_exited():
	$SelectionR.hide()

func _on_collision_l_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed == true:
		processClick(-1, event.button_mask)

func _on_collision_r_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed == true:
		processClick(1, event.button_mask)

func processClick(side: int, button_mask):
	if button_mask == 1:
		prismClicked.emit(index, side, button_mask)
	elif button_mask == 2:
		prismClicked.emit(index, side, button_mask)
		
	# Signal: (index of prism, side of prism -1=L 1=R, click of mouse 1=L 2=R)
