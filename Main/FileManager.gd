extends Node


func save_file(file_path: String):
	# Make sure it has .txt
	if !file_path.ends_with(".txt"):
		file_path += ".txt"
	
	var f = File.new()
	f.open(file_path, File.WRITE)
	
	# store the nodes and their positions
	f.store_line(str(get_parent().get_node("Nodes").get_child_count()))
	for c_node in get_parent().get_node("Nodes").get_children():
		f.store_line(c_node.label + "," + 
			str(c_node.get_global_position().x) + "," + 
			str(c_node.get_global_position().y))
	
	# store the paths between nodes
	f.store_line(str(get_parent().get_node("Paths").get_child_count()))
	for c_path in get_parent().get_node("Paths").get_children():
		f.store_line(c_path.first_node.label + "," + c_path.second_node.label)
	
	f.close()

func load_file(file_path: String):
	var f = File.new()
	f.open(file_path, File.READ)
	
	# load nodes
	var numb_of_nodes = f.get_line()
	for _i in range(numb_of_nodes):
		var node_vars = f.get_line().split(",")
		var node_position = Vector2(node_vars[1], node_vars[2])
		get_parent().get_node("Nodes").create_node_named(node_vars[0], node_position)
		
	# loads paths
	var numb_of_paths = f.get_line()
	for _i in range(numb_of_paths):
		var paths_vars = f.get_line().split(",")
		var first_node = get_parent().get_node("Nodes").get_node_by_label(paths_vars[0])
		var second_node = get_parent().get_node("Nodes").get_node_by_label(paths_vars[1])
		
		# check for nulls
		assert(first_node != null)
		assert(second_node != null)
		
		get_parent().get_node("Paths").create_path(first_node, second_node)
		
	
	f.close()
