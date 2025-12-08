extends Node

################### WARNING ###########
############# TERRIBLE CODE BELOW ########
####### !!!!!!!!##############

# Snake-related
var prism_scene := preload("res://prism.tscn")
var prism_mesh := preload("res://models/prism.obj")
var prism_mesh_dots := preload("res://models/prism_dots.obj")
var debug_dot := preload("res://debug_dot.tscn")
var snake_design: Array # Numbers design of the snake
var snake_prisms: Array # Array with prism nodes
var snake_length: int # Prism amount
var snake_object: Spatial # Node that contains all the prisms
var actions_history: Array # For undo

# Animation
var stunlock := 0 # For animations, 0 = none, 1 = prism rotation, 2 = whole rotation
var target_prisms: Array
var rotary_point: Spatial
var target_rotation: Basis
var time := 0.0
var rotation_queue := []
var center_point_rot: Vector3 # For rotations of whole
var rotary_node_rot: Spatial
var target_rotation_rot: Basis
var time_rot := 0.0

var CAMERA_ROOT: Spatial
var cam_recenter := false
var center_point_cam: Vector3
var time_cam := 0.0
var camera_movement_detected := false

var roto45 := false #for Z axis rotation so it dont get twisted
var lowest_Y_grid := 0.0 # for grid y level

var just_rotated_prism := false # for collision

# Settings
var gui_hidden := false

var spin_speed := 500
var instant_rotation := false
var animate_builds := false

var collision_blink_enabled := true
var allow_collisions := false
var blink_material := preload("res://materials/collision_blink_shader.tres")
var end_stickers_enabled := false
var dot_meshes_enabled := true
var block_cam_enabled := true

# Themes
var preset_backgrounds := {
	#"Default Dark": Color("10151a"),
	"Default Dark": Color("1C2026"),
	"Blendy Gray": Color("3F3F3F"),
	"Ugly Gray": Color("515b58"),
	"Steamy Blue": Color("1B2838"),
	"Light": Color("#F0F0F0"),
	"Green": Color("257444"),
	"Indigo": Color("432574"),
	"Blueprint Blue": Color("252e74"),
	"Midnight": Color("000000"),
}
var preset_backgrounds_array := [] # For option control nodes
var materials := {
	"White": load("res://materials/white.material"),
	"Black": load("res://materials/black.material"),
	"Gray": load("res://materials/gray.material"),
	"Mint Blue": load("res://materials/mint_blue.material"),
	"Mint Green": load("res://materials/mint_green.material"),
	"Blue": load("res://materials/blue.material"),
	"Red": load("res://materials/red.material"),
	"Orange": load("res://materials/orange.material"),
	"Yellow": load("res://materials/yellow.material"),
	"Green": load("res://materials/green.material"),
	"Cyan": load("res://materials/cyan.material"),
	"Purple": load("res://materials/purple.material"),
	"Pink": load("res://materials/pink.material"),
	"Cream": load("res://materials/cream.material"),
	"Brown": load("res://materials/brown.material"),
}
var materials_array := [] # For option control nodes
var preset_themes := {
	0: "Main themes:",
	"Snake Designer Default": ["Mint Blue", "White", "Mint Green", "White"],
	"Rubik's Twist": ["Black", "Blue", "Gray", "Red", "Black", "Orange", "Gray", "Yellow", "Black", "White", "Gray", "Green", "Black", "Green", "Gray", "White", "Black", "Yellow", "Gray", "Orange", "Black", "Red", "Gray", "Blue"],
	"Classic Snake": ["Blue", "Blue", "Green", "Green"],
	"Toy Snake": ["Blue", "Yellow", "White", "Yellow", "Blue", "Green", "White", "Green", "Blue", "Red", "White", "Red"],

	1: "Rainbows:",
	"Rainbow Snake": ["Blue", "Blue", "Green", "Green", "Yellow", "Yellow", "Orange", "Orange", "Red", "Red", "Purple", "Purple"],
	"Rainbow Snake W": ["White", "Blue", "White", "Cyan", "White", "Green", "White", "Yellow", "White", "Orange", "White", "Red", "White", "Purple"],
	"Rainbow Snake B": ["Black", "Blue", "Black", "Cyan", "Black", "Green", "Black", "Yellow", "Black", "Orange", "Black", "Red", "Black", "Purple"],
	"Rainbow Mirrored": ["Red", "Red", "Orange", "Orange", "Yellow", "Yellow", "Green", "Green", "Cyan", "Cyan", "Blue", "Blue", "Purple", "Purple", "Blue", "Blue", "Cyan", "Cyan", "Green", "Green", "Yellow", "Yellow", "Orange", "Orange"],
	"Rubik's Twist B&W": ["Black", "Blue", "White", "Red", "Black", "Orange", "White", "Yellow", "Black", "Gray", "White", "Green", "Black", "Green", "White", "Gray", "Black", "Yellow", "White", "Orange", "Black", "Red", "White", "Blue"],
	"Rubik's Twist B": ["Black", "Blue", "Black", "Red", "Black", "Orange", "Black", "Yellow", "Black", "White", "Black", "Green", "Black", "Green", "Black", "White", "Black", "Yellow", "Black", "Orange", "Black", "Red", "Black", "Blue"],
	"Rubik's Twist W": ["White", "Blue", "White", "Red", "White", "Orange", "White", "Yellow", "White", "Black", "White", "Green", "White", "Green", "White", "Black", "White", "Yellow", "White", "Orange", "White", "Red", "White", "Blue"],
	
	2: "Color x White:",
	"W Mint Blue": ["Mint Blue", "White", "White", "Mint Blue"],
	"W Mint Green": ["Mint Green", "White", "White", "Mint Green"],
	"W Blue": ["Blue", "White", "White", "Blue"],
	"W Green": ["Green", "White", "White", "Green"],
	"W Red": ["Red", "White", "White", "Red"],
	"W Orange": ["Orange", "White", "White", "Orange"],
	"W Yellow": ["Yellow", "White", "White", "Yellow"],
	"W Cyan": ["Cyan", "White", "White", "Cyan"],
	"W Purple": ["Purple", "White", "White", "Purple"],
	"W Pink": ["Pink", "White", "White", "Pink"],
	"W Cream": ["Cream", "White", "White", "Cream"],
	"W Brown": ["Brown", "White", "White", "Brown"],
	"W Black": ["Black", "White", "White", "Black"],
	"W Gray": ["Gray", "White", "White", "Gray"],
	
	3: "Solid Colors:",
	"S White": ["White"],
	"S Black": ["Black"],
	"S Gray": ["Gray"],
	"S Mint Blue": ["Mint Blue"],
	"S Mint Green": ["Mint Green"],
	"S Blue": ["Blue"],
	"S Red": ["Red"],
	"S Orange": ["Orange"],
	"S Yellow": ["Yellow"],
	"S Green": ["Green"],
	"S Cyan": ["Cyan"],
	"S Purple": ["Purple"],
	"S Pink": ["Pink"],
	"S Cream": ["Cream"],
	"S Brown": ["Brown"],
	
	4: "Fun:",
	"Space": ["Black", "Mint Blue", "Mint Blue", "Black"],
	"Missing Textures": ["Black", "Purple", "Purple", "Black"],
	"Elegant": ["Black", "Red", "Red", "Black"],
	"Orange Black": ["Black", "Orange", "Orange", "Black"],
	"Bee": ["Black", "Yellow", "Yellow", "Black"],
	"Toxic": ["Black", "Green", "Green", "Black"],
	"Ice Cream": ["Cream", "Pink", "Pink", "Cream"],
	"Coffee": ["Brown", "Cream", "Cream", "Brown"],
	"Piano": ["Black", "Black", "White", "White"],
	"Funky": ["Mint Blue", "Mint Blue", "Pink", "Pink"],
	"IKEA": ["Blue", "Yellow"],
	"Zebra": ["Black", "Black", "White", "White", "White", "White"],
	"Jungle Snek": ["Green", "Green", "Mint Blue", "Mint Blue", "Mint Blue", "Mint Blue"],
	"Desert Snek": ["Orange", "Orange", "Cream", "Cream", "Cream", "Cream"],
	"thomas-wolter.de": ["Mint Blue", "Mint Blue", "Mint Green", "Mint Green"]
}

var theme = preset_themes["Snake Designer Default"]

##################################################################

func _ready() -> void:
	CAMERA_ROOT = $World/CamGimbalY
	spawnEmptyDesign(24)
	
	for i in preset_backgrounds.keys():
		get_node("%BackgroundOptions").add_item(i)
		preset_backgrounds_array.append(preset_backgrounds[i])
	
	for i in preset_themes.keys():
		if i is int:
			var x = Label.new()
			x.text = preset_themes[i]
			x.add_font_override("font", load("res://icons/bigfont.tres"))
			x.align = Label.ALIGN_CENTER
			get_node("%PresetThemesVbox").add_child(x)
		else:
			var x = load("res://theme_button.tscn").instance()
			x.text = i
			x.this_theme = i
			get_node("%PresetThemesVbox").add_child(x)
			x.connect("themeButtonSelected", self, "themePresetPressed")
	
	$AnimationPlayer.play("blink_red_shader")


func _input(_event):
	if Input.is_action_just_pressed("undo"):
		rotateSnakeUndo()
		$UndoTimer.start()
	if Input.is_action_just_pressed("home_cam"):
		resetCam()
	if Input.is_action_just_pressed("hide_gui"):
		toggleGuiHide()


func _process(delta):
	# Snake piece rotation
	if stunlock == 1:
		time += delta
		var a = Quat(rotary_point.transform.basis.get_rotation_quat())
		var b = Quat(target_rotation.get_rotation_quat())
		var c = a.slerp(b, Tools.damp(spin_speed, time*delta))
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
			if rotation_queue != []:
				moveRotateAnimQueue()
			else:
				stunlock = 0
				checkPrismCollisions()
	
	
	# Snake entire rotation
	elif stunlock == 2:
		time_rot += delta
		var a = Quat(rotary_node_rot.transform.basis.get_rotation_quat())
		var b = Quat(target_rotation_rot.get_rotation_quat())
		var c = a.slerp(b, Tools.damp(spin_speed/2.0, (time_rot)*delta))
		rotary_node_rot.transform.basis = Basis(c)
		
		if rotary_node_rot.transform.basis.is_equal_approx(target_rotation_rot):
			rotary_node_rot.transform.basis = target_rotation_rot
			
			for i in snake_prisms:
				var correct_position = i.global_transform
				rotary_node_rot.remove_child(i)
				snake_object.add_child(i)
				i.global_transform = correct_position
			
			rotary_node_rot.queue_free()
			time_rot = 0.0
			stunlock = 0
	
	# Camera re-center
	if cam_recenter:
		time_cam += delta
		CAMERA_ROOT.rotation_degrees.y = lerp(CAMERA_ROOT.rotation_degrees.y, 0, Tools.damp(50, time_cam*delta))
		CAMERA_ROOT.get_node("CamGimbalX").rotation_degrees.x = lerp(CAMERA_ROOT.get_node("CamGimbalX").rotation_degrees.x, 0, Tools.damp(50, time_cam*delta))
		CAMERA_ROOT.global_translation = lerp(CAMERA_ROOT.global_translation, center_point_cam, Tools.damp(50, time_cam*delta))
		
		if (CAMERA_ROOT.global_translation.is_equal_approx(center_point_cam) and round(CAMERA_ROOT.rotation_degrees.y) == 0 and round(CAMERA_ROOT.get_node("CamGimbalX").rotation_degrees.x) == 0) or camera_movement_detected:
			time_cam = 0.0
			cam_recenter = false
			camera_movement_detected = false
	
	# Grid re-level
	var current_y = findLowestY()
	if current_y < lowest_Y_grid:
		lowest_Y_grid = current_y
	get_node("%GridPlane").global_translation.y = lerp(get_node("%GridPlane").global_translation.y, lowest_Y_grid-1, Tools.damp(200, delta))

func findLowestY():
	var lowest_y := 9999.0
	for i in snake_prisms:
		if i.global_translation.y < lowest_y: lowest_y = i.global_translation.y
	return(lowest_y)

func checkPrismCollisions():
	$CollisionsTimer.start()

func _on_CollisionsTimer_timeout():
	$CollisionsTimer.stop()
	var undo_collision := false
	
	for i in snake_prisms:
		var x = i.get_node("CollisionMini").get_overlapping_areas()
		if x != []:
			if collision_blink_enabled: i.get_node("PrismMesh").set_material_overlay(blink_material)
			if !allow_collisions and just_rotated_prism: undo_collision = true
		else:
			i.get_node("PrismMesh").set_material_overlay(null)
	
	if undo_collision:
		rotateSnakeUndo()
	just_rotated_prism = false

func spawnEmptyDesign(count: int):
	spawnDesign(generateEmptyDesign(count))


func generateEmptyDesign(count: int):
	var x := []
	for i in count-1:
		x.append(0)
	return(x)


func spawnDesign(design: Array, animated: bool = false, orientation: Vector3 = Vector3(0, 0, 0)) -> void:
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
		piece.get_node("SelectionMini").set_surface_material(0, load("res://materials/selection_dark.material"))
		
		piece.translation.x = 0.5*i
		if i % 2 == 1:
			piece.transform.basis.x = Vector3(1,0,0)
			piece.transform.basis.y = Vector3(0,-1,0)
			piece.transform.basis.z = Vector3(0,0,-1)
			piece.translation.y = 0.5
	
	if end_stickers_enabled: spawnEndStickers()
	if dot_meshes_enabled: spawnDotMeshes()
	themeSet()
	
	if orientation != Vector3(0, 0, 0):
		var oronodo = Spatial.new()
		oronodo.translation = findCenter()
		snake_object.add_child(oronodo)
		for i in snake_prisms:
			var correct_pos = i.global_transform
			snake_object.remove_child(i)
			oronodo.add_child(i)
			i.global_transform = correct_pos
		oronodo.global_rotation = orientation
		for i in snake_prisms:
			var correct_pos = i.global_transform
			oronodo.remove_child(i)
			snake_object.add_child(i)
			i.global_transform = correct_pos
		oronodo.queue_free()
	
	# INFO Snake piece rotation phase
	if animated:
		resetCam()
		rotation_queue = []
		for i in len(design):
			if design[i] == 1:
				rotation_queue.append([i, 1, 1])
			elif design[i] == 2:
				rotation_queue.append([i, 1, 1])
				rotation_queue.append([i, 1, 1])
			elif design[i] == 3:
				rotation_queue.append([i, 1, -1])
		moveRotateAnimQueue()
	else:
		for i in len(design):
			if design[i] == 1:
				rotateSnake(i, 1, 1)
			elif design[i] == 2:
				rotateSnake(i, 1, 1)
				rotateSnake(i, 1, 1)
			elif design[i] == 3:
				rotateSnake(i, 1, -1)
		resetCam()
	
	lowest_Y_grid = 0.0
	just_rotated_prism = false

func convertToDesign(x: String):
	var m := []
	for i in x:
		m.append(int(i))
	return m

func themeSet():
	var repeat_num = 0
	for i in snake_prisms:
		i.get_node("PrismMesh").set_surface_material(0, materials[theme[repeat_num]])
		repeat_num += 1
		if repeat_num >= len(theme): repeat_num = 0
		i.get_node("PrismMesh").set_surface_material(1, materials[theme[repeat_num]])
		repeat_num += 1
		if repeat_num >= len(theme): repeat_num = 0


func moveRotateAnimQueue():
	if rotation_queue != []:
		rotateSnakeAnim(rotation_queue[0][0], rotation_queue[0][1], rotation_queue[0][2])
		$ClickAudio.play()
		rotation_queue.remove(0)


func rotateSnakeAction(index: int, side: int, rotate_direction: int):
	if stunlock != 0 or just_rotated_prism:
		return
	
	if (index == 0 and side == -1) or (index == snake_length-1 and side == 1):
		return
	
	actions_history.append([index, side, rotate_direction])
	if len(actions_history) > 150:
		actions_history.remove(0)
	
	just_rotated_prism = true
	if instant_rotation: rotateSnake(index, side, rotate_direction)
	else: rotateSnakeAnim(index, side, rotate_direction)
	get_node("%UndoButton").show()
	$ClickAudio.play()
	if block_cam_enabled:
		CAMERA_ROOT.block_cam = true


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
	
	elif side == -1:
		snake_design[index-1] = clamp0and3(snake_design[index-1]+rotate_direction)
		var origin_node = snake_prisms[index].get_node("OriginL")
		for i in snake_prisms.slice(0, index-1):
			rotateAround(i, origin_node.global_translation, origin_node.global_transform.basis.y, PI/2*rotate_direction)
	
	checkPrismCollisions()

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
	center_point_cam = findCenter()
	CAMERA_ROOT.zoom_level = 16.0 * (snake_length/24.0)
	cam_recenter = true
	lowest_Y_grid = 999
	camera_movement_detected = false


func findCenter():
	var x = Vector3(0, 0, 0)
	for i in snake_prisms:
		x += i.global_translation
	x = x / snake_length
	return x


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
	get_node("%AnimateImportCheck").pressed = animate_builds


func _on_ExportDesignButton_pressed():
	if stunlock != 0: return
	$ButtonAudio.play()
	var designtext := ""
	for i in snake_design:
		designtext += str(i)
	designtext += "|" + getFirstPrismOrientationInString()
	get_node("%ExportPopup").popup()
	get_node("%ExportBox").set_text(designtext)

func getFirstPrismOrientationInString(index: int = 0):
	var transforms := []
	transforms.append(round(rad2deg(snake_prisms[index].global_rotation.x)))
	transforms.append(round(rad2deg(snake_prisms[index].global_rotation.y)))
	transforms.append(round(rad2deg(snake_prisms[index].global_rotation.z)))
	return str(transforms[0]) +","+ str(transforms[1]) +","+ str(transforms[2])


func _on_DefaultRotationButton_pressed():
	if stunlock != 0: return
	spawnDesign(snake_design)


func _on_ImportDesign_pressed():
	if stunlock != 0: return
	
	var m = get_node("%ImportBox").text.split("|") #m[0] design, m[1] rotation
	
	if len(m[0]) > 479:
		get_node("%ImportStatus").text = "Too long! Max. 480 pieces"
		return
	elif len(m[0]) == 0:
		get_node("%ImportStatus").text = "Empty import!"
		return
	
	var temp_design := []
	for i in m[0]:
		if i != "0" and i != "1" and i != "2" and i != "3":
			get_node("%ImportStatus").text = "Wrong format!"
			return
		temp_design.append(int(i))
	
	var orientation: Vector3
	if len(m) == 2:
		orientation = convertOrientationStringToVector(m[1])
	else: orientation = Vector3(0, 0, 0)
	
	if animate_builds: spawnDesign(temp_design, true, orientation)
	else: spawnDesign(temp_design, false, orientation)
	get_node("%ImportPopup").hide()

func convertOrientationStringToVector(x: String):
	var orientationvector: Vector3
	var orientationarray = x.split(",")
	if len(orientationarray) == 3:
		orientationvector.x = deg2rad(clamp(float(orientationarray[0]), -180.0, 180.0))
		orientationvector.y = deg2rad(clamp(float(orientationarray[1]), -180.0, 180.0))
		orientationvector.z = deg2rad(clamp(float(orientationarray[2]), -180.0, 180.0))
	else: orientationvector = Vector3(0, 0, 0)
	return orientationvector

func _on_CopyExportToClipboardButton_pressed():
	$CollisionAudio.play()
	OS.set_clipboard(get_node("%ExportBox").text)


func _on_24Button_pressed():
	$CollisionAudio.play()
	get_node("%NewSnakeLengthBox").value = 24
func _on_36Button_pressed():
	$CollisionAudio.play()
	get_node("%NewSnakeLengthBox").value = 36
func _on_48Button_pressed():
	$CollisionAudio.play()
	get_node("%NewSnakeLengthBox").value = 48
func _on_60Button_pressed():
	$CollisionAudio.play()
	get_node("%NewSnakeLengthBox").value = 60
func _on_72Button_pressed():
	$CollisionAudio.play()
	get_node("%NewSnakeLengthBox").value = 72
func _on_120Button_pressed():
	$CollisionAudio.play()
	get_node("%NewSnakeLengthBox").value = 120
func _on_240Button_pressed():
	$CollisionAudio.play()
	get_node("%NewSnakeLengthBox").value = 240


func _on_GenerateRandomButton_pressed():
	$CollisionAudio.play()
	randomize()
	var x := ""
	var choices_num := ["0", "1", "2", "3"]
	for _i in range(23):
		x += (choices_num[rand_range(0, len(choices_num))])
	x = x + "|" + str(round(rand_range(-4, 5))*45) + "," + str(round(rand_range(-4, 5))*45) + "," + str(round(rand_range(-4, 5))*45)
	get_node("%ImportBox").text = x


func _on_HideUiButton_pressed():
	toggleGuiHide()


func _on_UnhideUiButton_pressed():
	toggleGuiHide()


func toggleGuiHide():
	if gui_hidden:
		gui_hidden = false
		$GUI.show()
		$UnhideUiButton.hide()
	else:
		gui_hidden = true
		$ButtonAudio.play()
		$GUI.hide()
		$UnhideUiButton.show()
		$UnhideUiButton.text = "CLICK HERE TO UNHIDE"
		$UnhideUITimer.start()


func _on_UnhideUITimer_timeout():
		$UnhideUiButton.text = ""


func _on_SettingsButton_pressed():
	if stunlock != 0: return
	$ButtonAudio.play()
	get_node("%SettingsPopup").show()


func _on_AnimateCheck_pressed():
	$UndoAudio.play()
	animate_builds = get_node("%AnimateImportCheck").pressed


func _on_FovSpinBox_value_changed(value):
	CAMERA_ROOT.get_node("CamGimbalX").get_node("Camera3D").fov = value


func _on_CloseSettingsButton_pressed():
	$CollisionAudio.play()
	get_node("%SettingsPopup").hide()


func _on_Sounds1Check_pressed():
	get_node("%Sounds1Check").pressed = true
	get_node("%Sounds2Check").pressed = false
	get_node("%Sounds3Check").pressed = false
	$ClickAudio.stream = load("res://sounds/click_1.wav")
	$UndoAudio.stream = load("res://sounds/undo_1.wav")
	$ClickAudio.play()
func _on_Sounds2Check_pressed():
	get_node("%Sounds1Check").pressed = false
	get_node("%Sounds2Check").pressed = true
	get_node("%Sounds3Check").pressed = false
	$ClickAudio.stream = load("res://sounds/click_2.wav")
	$UndoAudio.stream = load("res://sounds/undo_2.wav")
	$ClickAudio.play()
func _on_Sounds3Check_pressed():
	get_node("%Sounds1Check").pressed = false
	get_node("%Sounds2Check").pressed = false
	get_node("%Sounds3Check").pressed = true
	$ClickAudio.stream = load("res://sounds/click_3.wav")
	$UndoAudio.stream = load("res://sounds/undo_3.wav")
	$ClickAudio.play()


func _on_SoundsCheck_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		$SuccessAudio.play()
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func _on_EnableGridCheck_toggled(button_pressed):
	$UndoAudio.play()
	if button_pressed: get_node("%GridPlane").show()
	else: get_node("%GridPlane").hide()

func _on_CollisionVisualsCheck_toggled(button_pressed):
	$UndoAudio.play()
	collision_blink_enabled = button_pressed
	if !button_pressed:
		for i in snake_prisms: i.get_node("PrismMesh").set_material_overlay(null)
	else: checkPrismCollisions()

func _on_CameraMouseCheck_toggled(button_pressed):
	$UndoAudio.play()
	var lmb := InputEventMouseButton.new()
	var rmb := InputEventMouseButton.new()
	lmb.button_index = 1
	rmb.button_index = 2
	
	if button_pressed:
		InputMap.action_add_event("cam_pan", lmb)
		InputMap.action_add_event("cam_rotate", rmb)
		block_cam_enabled = true
	else:
		InputMap.action_erase_event("cam_pan", lmb)
		InputMap.action_erase_event("cam_rotate", rmb)
		block_cam_enabled = false

func _on_AllowCollisionsCheck_toggled(button_pressed):
	$UndoAudio.play()
	allow_collisions = button_pressed


func _on_ResetDefaultSettingsButton_pressed():
	$CollisionAudio.play()
	get_node("%RotationSpeedBox").value = 50
	get_node("%InstantRotationCheck").pressed = false
	get_node("%DarkenFirstPieceCheck").pressed = false
	get_node("%FovSpinBox").value = 45
	get_node("%SoundsCheck").pressed = true
	get_node("%EnableGridCheck").pressed = true
	_on_Sounds2Check_pressed()
	get_node("%AllowCollisionsCheck").pressed = false
	get_node("%CollisionVisualsCheck").pressed = true
	get_node("%CameraMouseCheck").pressed = true


func _on_RotationSpeedBox_value_changed(value):
	spin_speed = value*10


func _on_InstantRotationCheck_toggled(button_pressed):
	$UndoAudio.play()
	if button_pressed: instant_rotation = true
	else: instant_rotation = false


func _on_DarkenFirstPieceCheck_toggled(button_pressed):
	$UndoAudio.play()
	if button_pressed: snake_prisms[0].get_node("PrismMesh").set_material_overlay(load("res://materials/overlay.material"))
	else: snake_prisms[0].get_node("PrismMesh").set_material_overlay(null)


func _on_CloseThemesButton_pressed():
	$CollisionAudio.play()
	get_node("%ThemesPopup").hide()


func _on_ThemesButton_pressed():
	$ButtonAudio.play()
	get_node("%ThemesPopup").show()


func _on_OptionButton_item_selected(index):
	CAMERA_ROOT.get_node("CamGimbalX").get_node("Camera3D").environment.background_color = preset_backgrounds_array[index]


func themePresetPressed(theme_preset):
	$CollisionAudio.play()
	theme = preset_themes[theme_preset]
	themeSet()


func _on_RotoACW_pressed():
	rotateEntireSnake(true, -1)

func _on_RotoCW_pressed():
	rotateEntireSnake(true, 1)

func _on_RotoL_pressed():
	rotateEntireSnake(false, -1)

func _on_RotoR_pressed():
	rotateEntireSnake(false, 1)

func rotateEntireSnake(rotating_y, dir):
	if stunlock != 0: return
	#if roto45 and rotating_y:
	#	$WowowAudio.play()
	#	return
	
	center_point_rot = findCenter()
	rotary_node_rot = Spatial.new()
	rotary_node_rot.translation = center_point_rot
	snake_object.add_child(rotary_node_rot)
	
	if rotating_y:
		target_rotation_rot = rotary_node_rot.transform.basis.rotated(rotary_node_rot.global_transform.basis.y.normalized(), -PI/4*dir)
	else:
		var cam_roto = (CAMERA_ROOT.rotation.y/PI)
		if cam_roto >= -0.25 and cam_roto <= 0.25:
			target_rotation_rot = rotary_node_rot.transform.basis.rotated(rotary_node_rot.global_transform.basis.z.normalized(), -PI/4*dir)
		elif cam_roto >= -0.75 and cam_roto <= -0.25:
			target_rotation_rot = rotary_node_rot.transform.basis.rotated(rotary_node_rot.global_transform.basis.x.normalized(), PI/4*dir)
		elif cam_roto >= 0.25 and cam_roto <= 0.75:
			target_rotation_rot = rotary_node_rot.transform.basis.rotated(rotary_node_rot.global_transform.basis.x.normalized(), -PI/4*dir)
		else:
			target_rotation_rot = rotary_node_rot.transform.basis.rotated(rotary_node_rot.global_transform.basis.z.normalized(), PI/4*dir)
		
		#roto45 = !roto45
	
	for i in snake_prisms:
		var correct_position = i.global_transform
		snake_object.remove_child(i)
		rotary_node_rot.add_child(i)
		i.global_transform = correct_position
	
	stunlock = 2
	$UndoAudio.play()


func _on_cameraMovementDetected():
	camera_movement_detected = true

"""FINISH SOMEDAY
func _on_InvertDesignButton_pressed():
	if stunlock != 0: return
	var revarray = snake_design.duplicate()
	revarray.invert()
	
	var orientation = getFirstPrismOrientationInString(snake_length-1)
	var flippedoro = convertOrientationStringToVector(orientation)
	flippedoro.y += PI
	print(flippedoro)
	
	spawnDesign(revarray, false, flippedoro)"""

func spawnEndStickers():
	if end_stickers_enabled:
		snake_prisms[0].get_node("OriginL").get_node("Sprite3D").show()
		snake_prisms[-1].get_node("OriginR").get_node("Sprite3D").show()
	else:
		snake_prisms[0].get_node("OriginL").get_node("Sprite3D").hide()
		snake_prisms[-1].get_node("OriginR").get_node("Sprite3D").hide()


func _on_EndStickersCheck_toggled(button_pressed):
	end_stickers_enabled = button_pressed
	spawnEndStickers()
	$CollisionAudio.play()

func spawnDotMeshes():
	if dot_meshes_enabled:
		snake_prisms[0].get_node("PrismMesh").mesh = prism_mesh_dots
		snake_prisms[-1].get_node("PrismMesh").mesh = prism_mesh_dots
	else:
		snake_prisms[0].get_node("PrismMesh").mesh = prism_mesh
		snake_prisms[-1].get_node("PrismMesh").mesh = prism_mesh

func _on_EndDotsCheck_toggled(button_pressed):
	dot_meshes_enabled = button_pressed
	spawnDotMeshes()
	$CollisionAudio.play()


func takeScreenshot():
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png("C:/Users/leose/Desktop/GODOTKA.png")
	
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	$Image.set_texture(texture)



