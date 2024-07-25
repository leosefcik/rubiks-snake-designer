extends Node

var prism_scene := preload("res://Prism.tscn")
var snake_design: Array # Numbers design of the snake
var snake_prisms: Array # Array with prism nodes
var snake_length: int # Prism amount
var snake_object: Spatial # Node that contains all the prisms
var actions_history: Array # For undo
var stunlock := false # For animations

var animations_toggle := true


func _ready() -> void:
	spawnEmptyDesign(24)


func _input(_event):
	if Input.is_action_just_pressed("undo"):
		rotateSnakeUndo()
		$UndoTimer.start()
	if Input.is_action_just_pressed("home_cam"):
		resetCam()

func _process(delta):
	if stunlock:
		pass


func spawnEmptyDesign(count: int):
	var x := []
	for i in count-1:
		x.append(0)
	spawnDesign(x)


func spawnDesign(design: Array) -> void:
	# INFO Reset phase
	if snake_object: snake_object.queue_free()
	snake_object = Spatial.new()
	snake_object.set_name("SnakeObject")
	$World.add_child(snake_object)
	actions_history = []
	get_node("%UndoButton").hide()
	
	snake_design = design.duplicate()
	snake_prisms = []
	snake_length = len(snake_design)+1
	
	# INFO Snake spawning phase
	for i in snake_length:
		var piece = prism_scene.instance()
		piece.name = "P"+str(i)
		snake_object.add_child(piece)
		piece.index = i
		piece.connect("prismClicked", self, "rotateSnakeAction")
		snake_prisms.append(piece)
		
		piece.get_node("SelectionL").set_surface_material(0, load("res://materials/Selection.material"))
		piece.get_node("SelectionR").set_surface_material(0, load("res://materials/Selection.material"))
		
		piece.translation.x = 0.5*i
		if i % 2 == 1:
			piece.transform.basis.x = Vector3(1,0,0)
			piece.transform.basis.y = Vector3(0,-1,0)
			piece.transform.basis.z = Vector3(0,0,-1)
			piece.translation.y = 0.5
			piece.get_node("PrismMesh").set_surface_material(0, load("res://materials/MintGreen.material"))
			piece.get_node("PrismMesh").set_surface_material(1, load("res://materials/White.material"))
		else:
			piece.get_node("PrismMesh").set_surface_material(0, load("res://materials/MintBlue.material"))
			piece.get_node("PrismMesh").set_surface_material(1, load("res://materials/White.material"))
	
	# INFO Snake piece rotation phase
	# X
	
	resetCam()


func rotateSnakeAction(index: int, side: int, rotate_direction: int):
	if (index == 0 and side == -1) or (index == snake_length-1 and side == 1):
		return
	
	actions_history.append([index, side, rotate_direction])
	if len(actions_history) > 128:
		actions_history.remove(0)
	
	rotateSnake(index, side, rotate_direction)
	get_node("%UndoButton").show()
	$ClickAudio.play()
	print(snake_design)


func rotateSnakeUndo():
	if actions_history == []: return
	rotateSnake(actions_history[-1][0], actions_history[-1][1], actions_history[-1][2]*-1)
	$UndoAudio.play()
	
	actions_history.resize(actions_history.size() - 1)
	if actions_history == []: get_node("%UndoButton").hide()


# INFO Signal: (index of prism, side of prism -1=L 1=R, click of mouse 1=L -1=R)
func rotateSnake(index: int, side: int, rotate_direction: int):
	if side == 1:
		snake_design[index] = clamp0and3(snake_design[index]+rotate_direction)
		var origin_node = snake_prisms[index].get_node("OriginR")
		for i in snake_prisms.slice(index+1, snake_length):
			rotateAround(i, origin_node.global_translation, origin_node.global_transform.basis.y, PI/2*rotate_direction)
	if side == -1:
		snake_design[index-1] = clamp0and3(snake_design[index-1]+rotate_direction)
		var origin_node = snake_prisms[index].get_node("OriginL")
		for i in snake_prisms.slice(0, index-1):
			rotateAround(i, origin_node.global_translation, origin_node.global_transform.basis.y, PI/2*rotate_direction)


func rotateAround(obj, point, axis, angle):
	axis = axis.normalized()
	obj.global_translate(-point)
	obj.transform = obj.transform.rotated(axis, -angle)
	obj.global_translate(point)


func clamp0and3(x: int):
	if x > 3:
		return(0)
	elif x < 0:
		return(3)
	return(x)


func resetCam():
	var center_point := Vector3(0,0,0)
	for i in snake_prisms:
		center_point += i.global_translation
	center_point = center_point / snake_length
	get_node("%CamGimbalY").global_translation = center_point


func _on_UndoTimer_timeout():
	if Input.is_action_pressed("undo"):
		rotateSnakeUndo()
		$UndoTimer.start()


func _on_NewDesignButton_pressed():
	get_node("%NewDesignPopup").visible = true


func _on_CreateNewDesignButton_pressed():
	spawnEmptyDesign(get_node("%NewSnakeLengthBox").value)
	get_node("%NewDesignPopup").hide()


func _on_ResetCamButton_pressed():
	resetCam()


func _on_UndoButton_pressed():
	rotateSnakeUndo()
