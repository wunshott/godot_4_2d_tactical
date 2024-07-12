extends Node2D

var held_object = null
# Called when the node enters the scene tree for the first time.
func _ready():
	 #for node in get_tree().get_nodes_in_group("pickable"):
		#node.clicked.connect(_on_pickable_clicked)
	#for node in self.get_children():
		#node.clicked.connect(_on_dice_clicked)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#
#func _on_dice_clicked(object):
	#if !held_object:
		#object.pickup()
		#held_object = object
	#
#
#func _unhandled_input(event) -> void:
	#if event is InputEventMouseButton and event.is_action_released("left_click"): #reads all inputs
		#if held_object and !event.pressed:
			#held_object.let_go(Input.get_last_mouse_velocity())
			#held_object = null
