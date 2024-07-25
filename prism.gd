extends Spatial

var index: int

signal prismClicked(index, side, rotation_direction)


func processClick(side: int, button_mask):
	if button_mask == 1:
		emit_signal("prismClicked", index, side, 1)
	elif button_mask == 2:
		emit_signal("prismClicked", index, side, -1)
		
	# Signal: (index of prism, side of prism -1=L 1=R, click of mouse 1=L -1=R)


func _on_CollisionL_mouse_entered():
	$SelectionL.show()


func _on_CollisionR_mouse_entered():
	$SelectionR.show()


func _on_CollisionL_mouse_exited():
	$SelectionL.hide()


func _on_CollisionR_mouse_exited():
	$SelectionR.hide()


func _on_CollisionL_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed == true:
		processClick(-1, event.button_mask)


func _on_CollisionR_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed == true:
		processClick(1, event.button_mask)
