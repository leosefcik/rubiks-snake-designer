extends Node

# Snake-related
var prism_scene := preload("res://prism.tscn")
var snake_design: Array # Numbers design of the snake
var snake_prisms: Array # Array with prism nodes
var snake_length: int # Prism amount
var snake_object: Spatial # Node that contains all the prisms
var actions_history: Array # For undo

# Animation
var stunlock := 0 # For animations, 0 = none, 1 = prism rotation
var target_prisms: Array
var rotary_point: Spatial
var target_rotation: Basis
var time = 0.0

var CAMERA_ROOT: Spatial
var cam_recenter := false
var center_point: Vector3
var time_cam = 0.0

# Settings
var animations_toggle := true
var freeform_orbit := false


func _ready() -> void:
	CAMERA_ROOT = $World/CamGimbalY
	spawnEmptyDesign(24)


func _input(_event):
	if Input.is_action_just_pressed("undo"):
		rotateSnakeUndo()
		$UndoTimer.start()
	if Input.is_action_just_pressed("home_cam"):
		resetCam()


func _process(delta):
	# Snake piece rotation
	if stunlock == 1:
		time += delta
		var a = Quat(rotary_point.transform.basis)
		var b = Quat(target_rotation)
		var c = a.slerp(b, Tools.damp(300, time*delta))
		rotary_point.transform.basis = Basis(c)
		
		if rotary_point.transform.basis.is_equal_approx(target_rotation):
			rotary_point.transform.basis = target_rotation
			
			for i in target_prisms:
				var correct_position = i.global_transform
				rotary_point.remove_child(i)
				snake_object.add_child(i)
				i.global_transform = correct_position
			
			rotary_point.queue_free()
			time = 0.0
			stunlock = 0
	
	# Camera re-center
	if cam_recenter:
		time_cam += delta
		CAMERA_ROOT.rotation_degrees.y = lerp(CAMERA_ROOT.rotation_degrees.y, 0, Tools.damp(50, time_cam*delta))
		CAMERA_ROOT.get_node("CamGimbalX").rotation_degrees.x = lerp(CAMERA_ROOT.get_node("CamGimbalX").rotation_degrees.x, 0, Tools.damp(50, time_cam*delta))
		CAMERA_ROOT.global_translation = lerp(CAMERA_ROOT.global_translation, center_point, Tools.damp(50, time_cam*delta))
		
		if CAMERA_ROOT.global_translation.is_equal_approx(center_point) and round(CAMERA_ROOT.rotation_degrees.y) == 0:
			time_cam = 0.0
			cam_recenter = false


func spawnEmptyDesign(count: int):
	spawnDesign(generateEmptyDesign(count))


func generateEmptyDesign(count: int):
	var x := []
	for i in count-1:
		x.append(0)
	return(x)


func spawnDesign(design: Array) -> void:
	# INFO Reset phase
	if snake_object: snake_object.queue_free()
	snake_object = Spatial.new()
	snake_object.set_name("SnakeObject")
	$World.add_child(snake_object)
	actions_history = []
	get_node("%UndoButton").hide()
	
	snake_length = len(design)+1
	snake_design = generateEmptyDesign(snake_length)
	snake_prisms = []
	
	# INFO Snake spawning phase
	for i in snake_length:
		var piece = prism_scene.instance()
		piece.name = "P"+str(i)
		snake_object.add_child(piece)
		piece.index = i
		piece.connect("prismClicked", self, "rotateSnakeAction")
		snake_prisms.append(piece)
		
		piece.get_node("SelectionL").set_surface_material(0, load("res://materials/selection.material"))
		piece.get_node("SelectionR").set_surface_material(0, load("res://materials/selection.material"))
		
		piece.translation.x = 0.5*i
		if i % 2 == 1:
			piece.transform.basis.x = Vector3(1,0,0)
			piece.transform.basis.y = Vector3(0,-1,0)
			piece.transform.basis.z = Vector3(0,0,-1)
			piece.translation.y = 0.5
			piece.get_node("PrismMesh").set_surface_material(0, load("res://materials/mint_green.material"))
			piece.get_node("PrismMesh").set_surface_material(1, load("res://materials/white.material"))
		else:
			piece.get_node("PrismMesh").set_surface_material(0, load("res://materials/mint_blue.material"))
			piece.get_node("PrismMesh").set_surface_material(1, load("res://materials/white.material"))
	
	# INFO Snake piece rotation phase
	for i in len(design):
		if design[i] == 1:
			rotateSnake(i, 1, 1)
		elif design[i] == 2:
			rotateSnake(i, 1, 1)
			rotateSnake(i, 1, 1)
		elif design[i] == 3:
			rotateSnake(i, 1, -1)
	resetCam()


func rotateSnakeAction(index: int, side: int, rotate_direction: int):
	if stunlock != 0:
		return
	
	if (index == 0 and side == -1) or (index == snake_length-1 and side == 1):
		return
	
	actions_history.append([index, side, rotate_direction])
	if len(actions_history) > 150:
		actions_history.remove(0)
	
	rotateSnakeAnim(index, side, rotate_direction)
	get_node("%UndoButton").show()
	$ClickAudio.play()


func rotateSnakeUndo():
	if stunlock != 0: return
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


# INFO Signal: (index of prism, side of prism -1=L 1=R, click of mouse 1=L -1=R)
func rotateSnakeAnim(index: int, side: int, rotate_direction: int):
	rotary_point = Spatial.new()
	snake_object.add_child(rotary_point)
	target_prisms = []
	
	if side == 1:
		snake_design[index] = clamp0and3(snake_design[index]+rotate_direction)
		rotary_point.global_transform = snake_prisms[index].get_node("OriginR").global_transform
		for i in snake_prisms.slice(index+1, snake_length):
			target_prisms.append(i)
	
	if side == -1:
		snake_design[index-1] = clamp0and3(snake_design[index-1]+rotate_direction)
		rotary_point.global_transform = snake_prisms[index].get_node("OriginL").global_transform
		for i in snake_prisms.slice(0, index-1):
			target_prisms.append(i)
	
	for i in target_prisms:
		var correct_position = i.global_transform
		snake_object.remove_child(i)
		rotary_point.add_child(i)
		i.global_transform = correct_position
	
	target_rotation = rotary_point.transform.basis.rotated(rotary_point.global_transform.basis.y.normalized(), -PI/2*rotate_direction)
	
	stunlock = 1


func clamp0and3(x: int):
	if x > 3:
		return(0)
	elif x < 0:
		return(3)
	return(x)


func resetCam():
	$WowowAudio.play()
	center_point = Vector3(0,0,0)
	for i in snake_prisms:
		center_point += i.global_translation
	center_point = center_point / snake_length
	CAMERA_ROOT.zoom_level = 8.0
	cam_recenter = true


func _on_UndoTimer_timeout():
	if Input.is_action_pressed("undo"):
		rotateSnakeUndo()
		$UndoTimer.start()


func _on_NewDesignButton_pressed():
	$ButtonAudio.play()
	get_node("%NewSnakeLengthBox").value = 24
	get_node("%NewDesignPopup").popup()


func _on_CreateNewDesignButton_pressed():
	if stunlock != 0: return
	$ButtonAudio.play()
	spawnEmptyDesign(get_node("%NewSnakeLengthBox").value)
	get_node("%NewDesignPopup").hide()


func _on_ResetCamButton_pressed():
	resetCam()


func _on_UndoButton_pressed():
	rotateSnakeUndo()


func _on_ImportDesignButton_pressed():
	if stunlock != 0: return
	$ButtonAudio.play()
	get_node("%ImportPopup").popup()
	get_node("%ImportStatus").text = "Enter your design string below"


func _on_ExportDesignButton_pressed():
	if stunlock != 0: return
	$ButtonAudio.play()
	var designtext := ""
	for i in snake_design:
		designtext += str(i)
	get_node("%ExportPopup").popup()
	get_node("%ExportBox").set_text(designtext)


func _on_DefaultRotationButton_pressed():
	if stunlock != 0: return
	spawnDesign(snake_design)


func _on_ImportDesign_pressed():
	if stunlock != 0: return
	if len(get_node("%ImportBox").text) > 479:
		get_node("%ImportStatus").text = "Too long! Max. 480 pieces"
		return
	
	var temp_design := []
	for i in get_node("%ImportBox").text:
		if i != "0" and i != "1" and i != "2" and i != "3":
			get_node("%ImportStatus").text = "Wrong format! Must only contain numbers 0-3"
			return
		temp_design.append(int(i))
	
	spawnDesign(temp_design)
	$ButtonAudio.play()
	get_node("%ImportPopup").hide()


func _on_CopyExportToClipboardButton_pressed():
	$ButtonAudio.play()
	OS.set_clipboard(get_node("%ExportBox").text)


func _on_24Button_pressed():
	get_node("%NewSnakeLengthBox").value = 24
func _on_36Button_pressed():
	get_node("%NewSnakeLengthBox").value = 36
func _on_48Button_pressed():
	get_node("%NewSnakeLengthBox").value = 48
func _on_60Button_pressed():
	get_node("%NewSnakeLengthBox").value = 60
func _on_72Button_pressed():
	get_node("%NewSnakeLengthBox").value = 72
func _on_120Button_pressed():
	get_node("%NewSnakeLengthBox").value = 120
func _on_240Button_pressed():
	get_node("%NewSnakeLengthBox").value = 240
