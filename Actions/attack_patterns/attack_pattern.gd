extends Node2D

class_name AttackPattern

@onready var attack_area = $AttackArea
@export var up_rotation: float = 270
@export var right_rotation: float = 0
@export var down_rotation: float = 90
@export var left_rotation: float = 180


var attack_pattern_visibility_bool: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("attack_menu"):
		toggle_attack_area()
		#turn off the atttack_area_target. won't trigger the enemy vats menu
		

func toggle_attack_area() -> void: #ensure the vats menu pops up with the attack reticle covers the target
	attack_pattern_visibility_bool = not attack_pattern_visibility_bool
	self.set_visible(attack_pattern_visibility_bool)
	attack_area.set_collision_layer_value(4,attack_pattern_visibility_bool)

func _on_area_up_mouse_entered():
	var tween = create_tween() #TODO play with animation over tweening this. # put the tweens in a sep funcction
	#measure the angle from the point you are at 
	# if its greater than 180 from its current position go CCW
	#add to rotation intead of setting it
	
	#if abs(attack_area.get_rotation_degrees() - up_rotation) > 180:
		
	tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,up_rotation,.1)
	




func _on_area_right_mouse_entered():
	var tween = create_tween()
	if abs(attack_area.get_rotation_degrees() - right_rotation) > 180:
		tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() , 360,.1)#ensures the reticle spins around the shortest distance
		return
	tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,right_rotation,.1)
	#tween.tween_property(attack_area, "rotation",right_rotation,.1)


func _on_area_down_mouse_entered():
	var tween = create_tween() 
	#tween.tween_property(attack_area, "rotation",down_rotation,.1)
	tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,down_rotation,.1)


func _on_area_left_mouse_entered():
	var tween = create_tween() 
	#tween.tween_property(attack_area, "rotation",left_rotation,.1)
	tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,left_rotation,.1)

