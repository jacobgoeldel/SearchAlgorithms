extends Node

signal updated_output_text(new_text)

var graph
var unvisited_nodes
var current_node
var current_distance
var distances
var node_paths
var heuristics
var console_text
var start_node
var end_node
var completed

func pathfind_start(from_node, to_node):
	start_node = from_node
	end_node = to_node
	
	console_text = "[b]Starting Sorting Algorithim...[/b]"
	graph = {}
	unvisited_nodes = {}
	distances = {}
	heuristics = {}
	node_paths = {}
	current_distance = 0
	current_node = null
	completed = false
	
	# add nodes to graph
	for graphNode in get_parent().get_node("Nodes").get_children():
		unvisited_nodes[graphNode] = true
		graph[graphNode] = {}
	
	# add paths between nodes
	for graphPath in get_parent().get_node("Paths").get_children():
		graph[graphPath.first_node][graphPath.second_node] = graphPath.distance
		graph[graphPath.second_node][graphPath.first_node] = graphPath.distance
	
	emit_signal("updated_output_text", console_text)


func pathfind_step():
	if completed:
		return true
	
	if current_node == null: # nothing has been checked yet, so go to start
		current_node = start_node
		distances[current_node] = 0
	else:
		# get the unvisted node that has the shortest distance currently
		current_node = null
		for NewNode in unvisited_nodes:
			if heuristics.has(NewNode):
				if current_node == null:
					current_node = NewNode
				elif heuristics[current_node] > heuristics[NewNode]:
					current_node = NewNode
		
		# clear the coloring of the previous search
		for graphPath in get_parent().get_node("Paths").get_children():
			if graphPath.path_color_state == 2:
				graphPath.path_color_state = 1
		
		# if the shortest current path is the end node, the search is completed, even if some nodes are skipped
		if current_node == end_node:
			current_node = null
		
		# there are no more nodes to check
		if current_node == null:
			console_text += "\n\n[b]Search Complete! Path:[/b]\n"
			
			# get a stack of the shortest path
			var path_list = []
			path_list.push_front(end_node)
			while path_list[0] != start_node:
				if !node_paths.has(path_list[0]):
					console_text += "There is no valid path to the end."
					completed = true
					return true
				path_list.push_front(node_paths[path_list[0]])
				
			# clear the coloring on the paths and color the final path
			for i in range(len(path_list) - 1):
				for graphPath in get_parent().get_node("Paths").get_children():
					if graphPath.has_nodes(path_list[i], path_list[i+1]):
						graphPath.path_color_state = 2
				
				
			# print the path
			for i in range(len(path_list)):
				console_text += path_list[i].label
				if i + 1 < len(path_list): # skip putting an arrow after the last node
					console_text += " -> "
			
			emit_signal("updated_output_text", console_text)
			
			completed = true
			return true
	
	console_text += "\n\n[b]Checking " + current_node.label + "...[/b]\n"
	
	# color all the paths that are going to be checked
	for graph_node in graph:
			for graphPath in get_parent().get_node("Paths").get_children():
				if graph_node in graph[current_node] and graphPath.has_nodes(graph_node, current_node):
					graphPath.path_color_state = 2
	
	# check each node that the current node connects to
	for node_can_path_to in graph[current_node].keys():
		var new_distance = int(graph[current_node][node_can_path_to]) + distances[current_node]
		console_text += "\n" + current_node.label + " -> " + node_can_path_to.label + " = " + str(new_distance)
		if !distances.has(node_can_path_to) or new_distance < distances[node_can_path_to]:
			console_text += "[i](new shortest)[/i]"
			
			distances[node_can_path_to] = new_distance
			
			# set what the next node should be chosen by, pure distance (dijkstras), or distance and distance to the end node (astar)
			heuristics[node_can_path_to] = new_distance
			if get_parent().algorithim == 1:
				heuristics[node_can_path_to] += node_can_path_to.global_position.distance_to(node_can_path_to.end_node.global_position)
			
			node_paths[node_can_path_to] = current_node
			
	# out the list of current paths as of the last step
	console_text += "\n\nCurrent Shortest Paths:"
	for node_path in node_paths.keys():
		console_text += "\n" + node_path.label + ": " + node_paths[node_path].label + " (" + str(distances[node_path]) + ")"
	
	# don't check this node again
	for graph_node in graph:
		graph[graph_node].erase(current_node)
	
	emit_signal("updated_output_text", console_text)
	unvisited_nodes.erase(current_node)
	return false


func pathfind_run():
	while pathfind_step() != true:
		continue


func pathfind_restart():
	pathfind_stop()
	pathfind_start(start_node, end_node)


func pathfind_stop():
	console_text = ""
	current_node = null
	graph = {}
	node_paths = {}
	heuristics = {}
	unvisited_nodes = {}
	distances = {}
	for graphPath in get_parent().get_node("Paths").get_children():
		graphPath.path_color_state = 0
