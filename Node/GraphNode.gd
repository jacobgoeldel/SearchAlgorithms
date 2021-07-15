extends Area2D

class_name SortGraphNode

enum EditorMode { CREATE, MOVE, DELETE, PATHCREATE, PATHDELETE }

export(Color) var color
export(bool) var can_be_deleted = true
export(String) var label = "label"
export(bool) var show_distance_to_end = false

var end_node
var moving = false

onready var main_node = get_parent().get_parent()

func _ready() -> void:
	$Sprite.modulate = color
	$Label.text = label


func _process(_delta: float) -> void:
	if moving:
		global_position = get_global_mouse_position()
	
	if end_node != null and show_distance_to_end and self != end_node:
		$DistanceLabel.visible = true
		$DistanceLabel.text = str(int(global_position.distance_to(end_node.global_position)))
	else:
		$DistanceLabel.visible = false
		


func _on_Label_text_changed(new_text: String) -> void:
	label = new_text
	get_parent().get_parent().get_node("UI").update_nodes_label(self)
