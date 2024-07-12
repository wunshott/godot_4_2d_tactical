extends Control

signal limb_hovered(limb_name: String)


@export var head: Control
@export var torso: Control
@export var RightArm: Control
@export var LeftArm: Control
@export var LeftLeg: Control
@export var RightLeg: Control



# Called when the node enters the scene tree for the first time.
func _ready():
	head.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(head))
	head.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(head))
	
	
	torso.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(torso))
	torso.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(torso))
	
	RightArm.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(RightArm))
	RightArm.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(RightArm))
	
	LeftArm.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(LeftArm))
	LeftArm.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(LeftArm))
	
	LeftLeg.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(LeftLeg))
	LeftLeg.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(LeftLeg))
	
	RightLeg.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(RightLeg))
	RightLeg.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(RightLeg))
	#self.connect("area_entered",Callable(self,"_on_area_entered"))
	pass # Replace with function body.

#TODO add slot
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_limb_mouse_entered(input_limb) -> void:
	for child in input_limb.get_children():
		if child is PanelContainer:
			child.show()
	limb_hovered.emit(input_limb.get_name()) #TODO make the function decide which part of the resource file to emit based on which limb you hover
	


func _on_limb_mouse_exited(input_limb) -> void:
	for child in input_limb.get_children():
		if child is PanelContainer:
			child.hide()
