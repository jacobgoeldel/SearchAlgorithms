extends Node2D

export(PackedScene) var GraphPathScene
var new_path

func create_path(first_node, second_node):
	new_path = GraphPathScene.instance()
	
	new_path.add_point(first_node.position)
	new_path.add_point(second_node.position)
	
	new_path.first_node = first_node
	new_path.second_node = second_node
	
	new_path.path_state = 1
	add_child(new_path)


func start_path(start_node: Node2D):
	new_path = GraphPathScene.instance()
	
	new_path.add_point(start_node.position)
	new_path.add_point(start_node.position)
	
	new_path.first_node = start_node
	
	add_child(new_path)


func clear_paths():
	for c_path in get_children():
		c_path.free()


func end_path(end_node: Node2D):
	if new_path != null:
		if end_node != null:
			new_path.second_node = end_node
		else:
			new_path.queue_free()
		new_path = null


func get_path_below_mouse() -> Node:
	var mousePos = get_global_mouse_position()
	var space = get_world_2d().direct_space_state
	var collision_objects = space.intersect_point(mousePos, 1, [], 2147483647, false, true)
	if collision_objects and collision_objects[0] is SortGraphPath:
		return collision_objects[0]
	return null
