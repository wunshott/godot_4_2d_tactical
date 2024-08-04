extends RigidBody2D


var _dragging: bool = false
var shape: Shape2D
@onready var collision_shape_2d = $CollisionShape2D


signal clicked
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		_dragging = !_dragging
	
	#elif event is InputEventMouseButton and event.is_action_released("left_click"):
		#_dragging = false
		#




func _physics_process(delta: float) -> void:
	if _dragging:
		var target_pos = get_global_mouse_position()
		#clamp the target position of the dice
		target_pos.x = clamp(target_pos.x,16,500)
		target_pos.y = clamp(target_pos.y,16,349)
		
		var displacement = target_pos - global_position
		var direction = displacement.normalized()
		var distance = displacement.length()
		
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		query.set_shape(collision_shape_2d.shape)
		query.transform = Transform2D(0, global_position)
		query.exclude = [self]
	
		var result = space_state.intersect_shape(query)
		for collision in result:
			var body = collision.collider
			print(body)
			if body is RigidBody2D:
				
				var body_displacement = body.global_position - global_position
				var body_direction = body_displacement.normalized()
				var push_force = (1.0/ max(1, body_displacement.length())) * 1000
				body.apply_central_impulse(body_direction * push_force)
			#if body is StaticBody2D:
				#_dragging = false
		#
	
		global_position = target_pos
