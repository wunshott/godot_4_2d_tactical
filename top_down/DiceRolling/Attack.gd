extends Area2D

@onready var dice_tray_roller = $".." as DiceTray


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",Callable(self,"_on_body_entered"))
	self.connect("body_exited",Callable(self,"_on_body_exited"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body: Node2D):
	if body is RigidDice:
		body.add_to_group("Attack")
		body.die_graphic.set_self_modulate(Color.RED)
		body.connect("dice_rolled",Callable(dice_tray_roller,"append_attack_dice_array"))

#reset_dice_button.connect("pressed",Callable(idx,"reset_starting_dice_position"))

func _on_body_exited(body: Node2D):
	if body is RigidDice:
		body.remove_from_group("Attack")
		body.die_graphic.reset_modulation()
		body.disconnect("dice_rolled",Callable(dice_tray_roller,"append_attack_dice_array"))
