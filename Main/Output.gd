extends WindowDialog


func _on_PathFinder_updated_output_text(new_text: String) -> void:
	$VBoxContainer/Label.bbcode_text = new_text
