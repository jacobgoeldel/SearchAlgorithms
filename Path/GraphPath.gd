extends Area2D

class_name SortGraphPath

enum EditorMode { CREATE, MOVE, DELETE, PATHCREATE, PATHDELETE }
enum PathState { CREATING, COMPLETED}
enum PathColorState { DEFAULT, SEARCHED, COMPLETED }

export(Color) var default_color
export(Color) var searched_color
export(Color) var completed_color

var first_node
var second_node
var path_state = PathState.CREATING
var path_color_state = PathColorState.DEFAULT
var distance = 0

# used so that collision of path doesn't go below a node
var collision_size_offset = 24

onready var main_node = get_parent().get_parent()

func _physics_process(_delta: float) -> void:
	if path_state == PathState.COMPLETED and second_node == null:
		queue_free()
	
	# set the color
	match path_color_state:
		PathColorState.DEFAULT:
			$Path.modulate = default_color
			$Collision/Distance.modulate = default_color
		PathColorState.SEARCHED:
			$Path.modulate = searched_color
			$Collision/Distance.modulate = searched_color
		PathColorState.COMPLETED:
			$Path.modulate = completed_color
			$Collision/Distance.modulate = completed_color
	
	if !Input.is_mouse_button_pressed(1) and path_state == PathState.CREATING and main_node.mode == EditorMode.PATHCREATE:
		path_state = PathState.COMPLETED
		for pth in get_parent().get_children():
				if pth != self and has_nodes(pth.first_node, pth.second_node):
					# it is a duplicate
					queue_free()
	
	if is_instance_valid(first_node):
		$Path.set_point_position(0, first_node.position)
	else:
		queue_free()
		return

	if second_node == null:
		$Path.set_point_position(1, get_global_mouse_position())
		_update_collision_shape(first_node.position, get_global_mouse_position())
	elif is_instance_valid(second_node):
		$Path.set_point_position(1, second_node.position)
		_update_collision_shape(first_node.position, second_node.position)
	else:
		queue_free()


func _on_GraphPath_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed == false and event.button_index == BUTTON_LEFT:
		if main_node.mode == EditorMode.PATHDELETE:
			queue_free()

func _update_collision_shape(point1: Vector2, point2: Vector2):
	var length = point1.distance_to(point2) / 2
	var angle = point1.angle_to_point(point2)
	var center_point = point1 + (point2 - point1) / 2
	
	distance = length * 2

	$Collision.shape.extents.x = length - collision_size_offset
	$Collision.global_rotation = angle
	$Collision.global_position = center_point

	$Collision/Distance.global_rotation = 0
	$Collision/Distance/Label.text = str(int(length * 2))


# checks if it has both nodes regardless of order
func has_nodes(node1: Node, node2: Node) -> bool:
	if first_node == node1 and second_node == node2:
		return true
	if first_node == node2 and second_node == node1:
		return true
	return false


func add_point(new_point: Vector2) -> void:
	$Path.add_point(new_point)
