extends Node

var prism_scene := preload("res://prism.tscn")
var design_array := []
var pieces_count := 24


func _ready() -> void:
	spawnNewDesign()


func _process(delta: float) -> void:
	pass


func _on_new_design_pressed() -> void:
	%NewDesignPopup.visible = true


func _on_create_new_design_pressed() -> void:
	pass # Replace with function body.


func spawnNewDesign() -> void:
	design_array = []
	for i in pieces_count-1:
		design_array.append(0)
	
	for i in pieces_count:
		var piece := prism_scene.instantiate()
		piece.name = "P"+str(i)
		%SnakeObject.add_child(piece)
		piece.index = i
		piece.prismClicked.connect(rotateSnake)
		
		piece.position.x = 0.5*i
		if i % 2 == 1:
			piece.basis.x = Vector3(1,0,0)
			piece.basis.y = Vector3(0,-1,0)
			piece.basis.z = Vector3(0,0,-1)
			piece.position.y = 0.5
	
	%SnakeObject/P1/PrismMesh.set_surface_override_material(0, load("res://materials/MintGreen.tres"))
	var t = %SnakeObject/P1
	var oldpos = t.global_transform
	%SnakeObject.remove_child(t)
	%SnakeObject/P0/OriginR.add_child(t)
	t.global_transform = oldpos

# Signal: (index of prism, side of prism -1=L 1=R, click of mouse 1=L 2=R)
func rotateSnake(index: int, side: int, rotate_direction: int):
	pass


func _on_export_design_pressed():
	pass
	#%SnakeObject/P0/OriginR.rotate_object_local(rotation.y, PI/2)
