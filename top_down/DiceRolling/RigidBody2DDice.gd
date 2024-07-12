extends RigidBody2D

class_name RigidDice

@export var die_graphic: AnimatedSprite2D
@export var die_number: Sprite2D

var _dragging: bool = false
var shape: Shape2D
var starting_position: Vector2
var selected = false:
	set = set_selected
var dice_value: int = 12
var dice_outcome: int = randi_range(1,dice_value)

@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
@onready var selected_die_gfx = $SelectedDieGfx as Sprite2D
@onready var gpu_particles_2d = $GPUParticles2D as GPUParticles2D
@onready var dice_roll_animation = $AnimationPlayer as AnimationPlayer


signal clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	save_position()
	pass # Replace with function body.

func set_selected(value) -> void:
	selected = value
	selected_die_gfx.set_visible(selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_die_gfx() -> int:
	dice_outcome = randi_range(1,dice_value)
	die_graphic.set_frame(dice_outcome-1)
	die_number.set_frame(dice_outcome-1)
	return dice_outcome

func roll_die() -> void:
	dice_roll_animation.play("roll")

func reset_starting_dice_position() -> void:
	position = starting_position

func _on_input_event(viewport, event: InputEvent, shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		_dragging = !_dragging
		set_selected(!selected)
		if _dragging:
			gpu_particles_2d.set_emitting(false)
	#elif event is InputEventMouseButton and event.is_action_released("left_click"):
		#_dragging = false
		#

func save_position() -> void:
	starting_position = position


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


func _on_mouse_entered():
	if !_dragging:
		gpu_particles_2d.set_emitting(true)


func _on_mouse_exited():
	gpu_particles_2d.set_emitting(false)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "roll":
		print(dice_outcome)
