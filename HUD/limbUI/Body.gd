extends Control

signal limb_hovered(limb_name: String)


@export var head: Control
@export var HeadButton: TextureButton
@export var torso: Control
@export var TorsoButton: TextureButton
@export var RightArm: Control
@export var RightArmButton: TextureButton
@export var LeftArm: Control
@export var LeftArmButton: TextureButton
@export var LeftLeg: Control
@export var LeftLegButton: TextureButton
@export var RightLeg: Control
@export var RightLegButton: TextureButton

var current_pressed_button: TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	#head.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(head))
	#head.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(head))
	HeadButton.connect("toggled",Callable(self,"_on_limb_button_pushed").bind(head,HeadButton))
	
	
	#torso.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(torso))
	#torso.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(torso))
	TorsoButton.connect("toggled",Callable(self,"_on_limb_button_pushed").bind(torso,TorsoButton))
	
	#RightArm.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(RightArm))
	#RightArm.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(RightArm))
	RightArmButton.connect("toggled",Callable(self,"_on_limb_button_pushed").bind(RightArm,RightArmButton))
	
	#LeftArm.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(LeftArm))
	#LeftArm.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(LeftArm))
	LeftArmButton.connect("toggled",Callable(self,"_on_limb_button_pushed").bind(LeftArm,LeftArmButton))
	
	#LeftLeg.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(LeftLeg))
	#LeftLeg.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(LeftLeg))
	LeftLegButton.connect("toggled",Callable(self,"_on_limb_button_pushed").bind(LeftLeg,LeftLegButton))
	
	
	#RightLeg.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(RightLeg))
	#RightLeg.connect("mouse_exited",Callable(self,"_on_limb_mouse_exited").bind(RightLeg))
	RightLegButton.connect("toggled",Callable(self,"_on_limb_button_pushed").bind(RightLeg,RightLegButton))
	
	#self.connect("area_entered",Callable(self,"_on_area_entered"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func untoggle_button(new_pressed_button: TextureButton) -> void:
	#print_debug(new_pressed_button)
	#print_debug(current_pressed_button)
	if !current_pressed_button:
		current_pressed_button = new_pressed_button
		return
	
	if current_pressed_button != new_pressed_button:
		current_pressed_button.set_pressed(false)
		current_pressed_button = new_pressed_button
		
	
	# set the currently pressed button variable to unpressed
	# override with the currently_pressed_button




func _on_limb_button_pushed(toggled_bool: bool, input_limb: Control, pushed_button: TextureButton) -> void:
	if toggled_bool:
		for child in input_limb.get_children():
			if child is PanelContainer:
				child.show()
		limb_hovered.emit(input_limb.get_name()) 
		untoggle_button(pushed_button)
	else:
		for child in input_limb.get_children():
			if child is PanelContainer:
				child.hide()

func _on_limb_mouse_entered(input_limb) -> void:
	
	
	for child in input_limb.get_children():
		if child is PanelContainer:
			child.show()
	limb_hovered.emit(input_limb.get_name()) 
	


func _on_limb_mouse_exited(input_limb) -> void:
	for child in input_limb.get_children():
		if child is PanelContainer:
			child.hide()
