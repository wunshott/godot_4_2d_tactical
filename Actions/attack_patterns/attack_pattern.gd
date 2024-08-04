extends Node2D

class_name AttackPattern

@onready var attack_area = $AttackArea as Area2D
@export var up_rotation: int = 270
@export var right_rotation: int = 0
@export var down_rotation: int = 90
@export var left_rotation: int = 180


var attack_pattern_visibility_bool: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_area.monitoring = false
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
	attack_area.monitoring = attack_pattern_visibility_bool
	#attack_area.set_collision_layer_value(4,attack_pattern_visibility_bool)

func _on_area_up_mouse_entered():
	var tween = create_tween()

	var angle_to_move: int =  attack_area.get_rotation_degrees() - up_rotation 
	

	if angle_to_move == (180-270): #need to move from 180 to 270
		tween.tween_property(attack_area, "rotation_degrees", left_rotation + 90,.1)
	elif angle_to_move == (-270): #need to move from 0 to 270
		tween.tween_property(attack_area, "rotation_degrees", right_rotation - 90,.1)
		await tween.finished
		attack_area.set_rotation_degrees(270)
	else: # move from 90 to 270
		tween.tween_property(attack_area, "rotation_degrees", down_rotation + 180,.1)
	
	##tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,up_rotation,.1)



func _on_area_right_mouse_entered():
	var tween = create_tween()
	
	var angle_to_move: int =  attack_area.get_rotation_degrees() - right_rotation 
	

	if angle_to_move == (180): #need to move from 180 to 0
		tween.tween_property(attack_area, "rotation_degrees", left_rotation - 180,.1)
	elif angle_to_move == (270): #need to move from 270 to 0
		tween.tween_property(attack_area, "rotation_degrees", up_rotation + 90 ,.1)
		await tween.finished
		attack_area.set_rotation_degrees(0) # set to 0 to reset the rotation
	else: # move from 90 to 0
		tween.tween_property(attack_area, "rotation_degrees", down_rotation - 90,.1)
	
	
	#if abs(attack_area.get_rotation_degrees() - right_rotation) > 180:
		#tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() , 360,.1)#ensures the reticle spins around the shortest distance
		#return
	#tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,right_rotation,.1)



func _on_area_down_mouse_entered():
	var tween = create_tween() 
	var angle_to_move: int =  attack_area.get_rotation_degrees() - down_rotation 

	if angle_to_move == (90): #need to move from 180 to 90
		tween.tween_property(attack_area, "rotation_degrees", left_rotation - 90,.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	elif angle_to_move == (270): #need to move from 270 to 90
		tween.tween_property(attack_area, "rotation_degrees", right_rotation - 180 ,.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		#attack_area.set_rotation_degrees(0) # set to 0 to reset the rotation
	else: # move from 0 to 90
		tween.tween_property(attack_area, "rotation_degrees", right_rotation + 90,.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,down_rotation,.1)


func _on_area_left_mouse_entered():
	var tween = create_tween() 
	
	var angle_to_move: int =  attack_area.get_rotation_degrees() - left_rotation 
	
	
	if angle_to_move == (90): #need to move from 270 to 180
		tween.tween_property(attack_area, "rotation_degrees", up_rotation - 90,.1)
	elif angle_to_move == (270): #need to move from 0 to 180
		tween.tween_property(attack_area, "rotation_degrees", right_rotation + 180 ,.1)
		#attack_area.set_rotation_degrees(0) # set to 0 to reset the rotation
	else: # move from 90 to 180
		tween.tween_property(attack_area, "rotation_degrees", down_rotation + 90,.1)
	#tween.tween_method(attack_area.set_rotation_degrees, attack_area.get_rotation_degrees() ,left_rotation,.1)



#condense the if statements to if angle/90 is even(180)/odd(270) or the 90 case? then do the thing with mouse. no areas needed
