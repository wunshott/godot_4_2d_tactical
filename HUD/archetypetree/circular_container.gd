extends Container

class_name CircularContainer


@export var circle_diameter: float = 200.0: set = _set_circle_diameter



func _set_circle_diameter(value: float) -> void:
	circle_diameter = value
	queue_sort()
	

func _sort_children():
	var num_children = get_child_count()
	if num_children == 0:
		return
		
	var angle_step = 2 * PI / num_children
	var radius = circle_diameter / 2.0
	var center = Vector2(radius, radius)

	for i in range(num_children):
		var child = get_child(i)
		if child is Control:
			var angle = i * angle_step
			var child_pos = center + Vector2(cos(angle), sin(angle)) * radius
			child.rect_position = child_pos - (child.rect_size / 2.0)

	# Optional: Adjust the minimum size of the container to accommodate the circle
func _get_minimum_size() -> Vector2:
	return Vector2(circle_diameter, circle_diameter)
