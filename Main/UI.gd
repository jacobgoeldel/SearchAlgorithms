extends CanvasLayer

var current_from_node
var current_to_node

func _ready() -> void:
	$TopPanel/Container/RunButton.disabled = true


func update_mode_label(new_text: String):
	$ModeLabel.text = "Active Mode: " + new_text


func add_node_to_combo_boxes(new_node: SortGraphNode):
	$TopPanel/Container/ToNodeChooser.add_item(new_node.label, new_node.get_instance_id())
	$TopPanel/Container/FromNodesChooser.add_item(new_node.label, new_node.get_instance_id())
	
	if $TopPanel/Container/ToNodeChooser.get_item_count() == 1:
		$TopPanel/Container/ToNodeChooser.set_item_disabled(0, true)
		current_from_node = 0
		
	if $TopPanel/Container/ToNodeChooser.get_item_count() == 2:
		$TopPanel/Container/FromNodesChooser.set_item_disabled(1, true)
		$TopPanel/Container/ToNodeChooser.select(1)
		$TopPanel/Container/RunButton.disabled = false
		current_to_node = 1
		update_end_node_in_nodes()


func remove_node_from_combo_boxes(node: SortGraphNode):
	var index = $TopPanel/Container/FromNodesChooser.get_item_index(node.get_instance_id())
	$TopPanel/Container/FromNodesChooser.remove_item(index)
	$TopPanel/Container/ToNodeChooser.remove_item(index)
	
	if $TopPanel/Container/ToNodeChooser.get_item_count() == 1:
		$TopPanel/Container/RunButton.disabled = true


func _on_FromNodesChooser_item_selected(index: int) -> void:
	if current_from_node != null:
		$TopPanel/Container/ToNodeChooser.set_item_disabled(current_from_node, false)
	$TopPanel/Container/ToNodeChooser.set_item_disabled(index, true)
	current_from_node = index


func _on_ToNodeChooser_item_selected(index: int) -> void:
	if current_to_node != null:
		$TopPanel/Container/FromNodesChooser.set_item_disabled(current_to_node, false)
	$TopPanel/Container/FromNodesChooser.set_item_disabled(index, true)
	current_to_node = index
	
	update_end_node_in_nodes()


func update_end_node_in_nodes():
	for nd in get_parent().get_node("Nodes").get_children():
		nd.end_node = get_to_node()


func update_nodes_label(node: SortGraphNode):
	var index = $TopPanel/Container/FromNodesChooser.get_item_index(node.get_instance_id())
	$TopPanel/Container/FromNodesChooser.set_item_text(index, node.label)
	$TopPanel/Container/ToNodeChooser.set_item_text(index, node.label)


func clear_combo_boxes():
	$TopPanel/Container/ToNodeChooser.clear()
	$TopPanel/Container/FromNodesChooser.clear()


func get_from_node():
	return instance_from_id($TopPanel/Container/FromNodesChooser.get_item_id(current_from_node))


func get_to_node():
	if current_to_node == null:
		return null
	return instance_from_id($TopPanel/Container/ToNodeChooser.get_item_id(current_to_node))

