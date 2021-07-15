extends Node2D

export(PackedScene) var GraphNodeScene

var node_number_gen = 0

func create_node_named(node_name: String, node_position: Vector2):
	var new_node = GraphNodeScene.instance()

	# add nodes information
	new_node.color = Color.dodgerblue
	new_node.label = node_name
	if get_parent().algorithim == 1:
		new_node.show_distance_to_end = true

	new_node.position = node_position
	new_node.end_node = get_parent().get_node("UI").get_to_node()
	add_child(new_node)
	
	get_parent().get_node("UI").add_node_to_combo_boxes(new_node)


func create_node(node_position: Vector2):
	var new_node = GraphNodeScene.instance()

	# add nodes information
	new_node.color = Color.dodgerblue
	new_node.label = generate_label()
	if get_parent().algorithim == 1:
		new_node.show_distance_to_end = true

	new_node.position = node_position
	new_node.end_node = get_parent().get_node("UI").get_to_node()
	add_child(new_node)
	
	get_parent().get_node("UI").add_node_to_combo_boxes(new_node)


func clear_nodes() -> void:
	# delete all nodes expect start and end
	for c_node in get_children():
		c_node.free()


func generate_label() -> String:
	node_number_gen += 1
	return "New Node " + str(node_number_gen)


func get_node_below_mouse() -> Node:
	var mousePos = get_global_mouse_position()
	var space = get_world_2d().direct_space_state
	var collision_objects = space.intersect_point(mousePos, 1, [], 2147483647, false, true)
	if collision_objects and collision_objects[0].collider is SortGraphNode:
		return collision_objects[0].collider
	return null


func get_node_by_label(label: String) -> Node:
	for node_to_check in get_children():
		if node_to_check.label == label:
			return node_to_check
			
	return null


