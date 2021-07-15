extends Node2D

class_name MainScene

enum EditorMode { CREATE, MOVE, DELETE, PATHCREATE, PATHDELETE, RUNNING }
enum Algorithim { DIJKSTRA, ASTAR }

var mode = EditorMode.CREATE
var algorithim = Algorithim.DIJKSTRA

var moving_node = false
var making_path = false
var new_path
var running = false

# get references to all of our important nodes
onready var algorithim_option = $UI/TopPanel/Container/AlgorithimChooser


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	algorithim_option.add_item("Dijkstra's", 0)
	algorithim_option.add_item("A Star", 1)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var clicked_node = $Nodes.get_node_below_mouse()
		var clicked_path = $Paths.get_path_below_mouse()
		
		if clicked_node != null:
			if mode == EditorMode.MOVE:
				clicked_node.moving = event.pressed
			elif mode == EditorMode.DELETE:
				$UI.remove_node_from_combo_boxes(clicked_node)
				clicked_node.queue_free()
			elif mode == EditorMode.PATHCREATE:
				if event.pressed:
					$Paths.start_path(clicked_node)
				else:
					$Paths.end_path(clicked_node)
		elif mode == EditorMode.CREATE and event.pressed:
			$Nodes.create_node(get_global_mouse_position())
		elif clicked_path != null and mode == EditorMode.PATHDELETE:
			clicked_path.queue_free()
		elif mode == EditorMode.PATHCREATE:
			$Paths.end_path(null)


func _on_AlgorithimChooser_item_selected(index: int) -> void:
	algorithim = index
	if algorithim == 0:
		for node in $Nodes.get_children():
			node.show_distance_to_end = false
	else:
		for node in $Nodes.get_children():
			node.show_distance_to_end = true


func update_mode(new_mode: int, mode_label: String):
	mode = new_mode
	$UI.update_mode_label(mode_label)


func toggle_running() -> void:
	if !running:
		running = true
		$UI/Output.popup()
		$UI/TopPanel.visible = false
		mode = EditorMode.RUNNING
		$UI/ModeLabel.text = ""
		$PathFinder.pathfind_start($UI.get_from_node(), $UI.get_to_node())
	else:
		running = false
		$UI/TopPanel.visible = true
		mode = EditorMode.CREATE
		$UI/ModeLabel.text = "Active Mode: Create Node"
		$PathFinder.pathfind_stop()


func _on_LoadFileDialog_file_selected(path: String) -> void:
	$Nodes.clear_nodes()
	$Paths.clear_paths()
	$UI.clear_combo_boxes()
	$FileManager.load_file(path)


func _on_SaveFileDialog_file_selected(path: String) -> void:
	$FileManager.save_file(path)


func _on_SaveButton_pressed() -> void:
	$UI/SaveFileDialog.show()
	$UI/LoadFileDialog.hide()


func _on_LoadButton_pressed() -> void:
	$UI/LoadFileDialog.show()
	$UI/SaveFileDialog.hide()


func _on_ClearButton_pressed() -> void:
	$Nodes.clear_nodes()
	$Paths.clear_paths()
	$UI.clear_combo_boxes()
